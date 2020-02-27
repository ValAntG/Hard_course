require 'rails_helper'

RSpec.describe QuestionsController, type: :controller do
  let(:user) { create :user }
  let(:question) { create(:question, user: user) }

  describe 'GET #index' do
    let(:questions) { create_list(:question, 2) }

    before { get :index }

    it { expect(assigns(:questions)).to match_array(questions) }
    it { expect(response).to render_template :index }
  end

  describe 'GET #show' do
    before { get :show, params: { id: question.id } }

    it { expect(assigns(:question)).to eq(question) }
    it { expect(response).to render_template :show }
  end

  describe 'GET #new' do
    before do
      sign_in_user(user)
      get :new
    end

    it { expect(assigns(:question)).to be_a_new(Question) }
    it { expect(response).to render_template :new }
  end

  describe 'GET #edit' do
    before do
      sign_in_user(user)
      get :edit, params: { id: question.id }
    end

    it { expect(assigns(:question)).to eq question }
    it { expect(response).to render_template :edit }
  end

  describe 'POST #create' do
    before { sign_in_user(user) }

    context 'with valid attributes' do
      subject(:post_create) { post :create, params: { question: attributes_for(:question) } }

      it 'the username of the created question is checked' do
        post_create
        expect(assigns(:question).user_id).to eq user.id
      end

      it { expect { post_create }.to change(Question, :count).by(1) }
      it { expect(post_create).to redirect_to question_path(assigns(:question)) }
    end

    context 'with invalid attributes' do
      subject(:post_create) { post :create, params: { question: attributes_for(:question, :invalid) } }

      it { expect { post_create }.not_to change(Question, :count) }
      it { expect(post_create).to render_template :new }
    end

    context 'with invalid title' do
      subject(:post_create) { post :create, params: { question: attributes_for(:question, :invalid_title) } }

      it { expect { post_create }.not_to change(Question, :count) }
      it { expect(post_create).to render_template :new }
    end

    context 'with invalid body' do
      subject(:post_create) { post :create, params: { question: attributes_for(:question, :invalid_body) } }

      it { expect { post_create }.not_to change(Question, :count) }
      it { expect(post_create).to render_template :new }
    end
  end

  describe 'PATCH #update' do
    before { sign_in_user(user) }

    context 'when valid attributes' do
      before do
        patch :update, params: { id: question.id, question: attributes_for(:question, :new_body, :new_title) }
        question.reload
      end

      it { expect(question.title).to eq(attributes_for(:question, :new_title)[:title]) }
      it { expect(question.body).to eq(attributes_for(:question, :new_body)[:body]) }
      it { expect(assigns(:question)).to eq(question) }
      it { expect(response).to redirect_to(question) }
    end

    context 'when edit invalid attributes' do
      before do
        patch :update, params: { id: question.id, question: attributes_for(:question, :invalid) }
        question.reload
      end

      it { expect(question.title).to eq(attributes_for(:question)[:title]) }
      it { expect(question.body).to eq(attributes_for(:question)[:body]) }
      it { expect(response).to render_template :edit }
    end

    context 'when edit invalid body' do
      before do
        patch :update, params: { id: question.id, question: attributes_for(:question, :invalid_body, :new_title) }
        question.reload
      end

      it { expect(question.title).to eq(attributes_for(:question)[:title]) }
      it { expect(question.body).to eq(attributes_for(:question)[:body]) }
      it { expect(response).to render_template :edit }
    end

    context 'when edit invalid title' do
      before do
        patch :update, params: { id: question.id, question: attributes_for(:question, :invalid_title, :new_body) }
        question.reload
      end

      it { expect(question.title).to eq(attributes_for(:question)[:title]) }
      it { expect(question.body).to eq(attributes_for(:question)[:body]) }
      it { expect(response).to render_template :edit }
    end

    context "when user edit someone else's question" do
      let(:user2) { create :user }

      before do
        sign_in_user(user2)
        patch :update, params: { id: question.id, question: attributes_for(:question, :new_body, :new_title) }
        question.reload
      end

      it { expect(question.title).to eq(attributes_for(:question)[:title]) }
      it { expect(question.body).to eq(attributes_for(:question)[:body]) }
    end
  end

  describe 'DELETE #destroy' do
    subject(:destroy_question) { delete :destroy, params: { id: question } }

    let(:answer) { create(:answer, question_id: question.id, user_id: user.id) }

    before do
      sign_in_user(user)
      create(:answer, question_id: question.id, user_id: user.id)
      create(:comment, commentable: question, user: user)
      create(:comment, commentable: question, user: user)
      create(:comment, commentable: answer, user: user)
      create(:comment, commentable: answer, user: user)
    end

    it { expect { destroy_question }.to change(Question, :count).by(-1) }
    it { expect(destroy_question).to redirect_to questions_path }
    it { expect { destroy_question }.to change(Answer, :count).by(-2) }
    it { expect { destroy_question }.to change(Comment, :count).by(-4) }
  end
end
