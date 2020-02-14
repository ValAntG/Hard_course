require 'rails_helper'

RSpec.describe QuestionsController, type: :controller do
  describe 'GET #index' do
    let(:questions) { create_list(:question, 2) }

    before { get :index }

    it 'populates an array of all questions' do
      expect(assigns(:questions)).to match_array(questions)
    end

    it 'renders index view' do
      expect(response).to render_template :index
    end
  end

  describe 'GET #show' do
    let(:question) { create(:question) }

    before { get :show, params: { id: question.id } }

    it 'assings the requested question to @question' do
      expect(assigns(:question)).to eq question
    end

    it 'assigns new answer for question' do
      expect(assigns(:answer)).to be_a_new(Answer)
    end

    it 'renders show view' do
      expect(response).to render_template :show
    end

    it 'builds new attachment for answer' do
      expect(assigns(:question).answers.first.attachments.first).to be_a_new(Attachment)
    end
  end

  describe 'GET #new' do
    let(:user) { create :user }

    before do
      sign_in_user(user)
      get :new
    end

    it 'assings a new Question to @question' do
      expect(assigns(:question)).to be_a_new(Question)
    end

    it 'builds new attachment for question' do
      expect(assigns(:question).attachments.first).to be_a_new(Attachment)
    end

    it 'renders new view' do
      expect(response).to render_template :new
    end
  end

  describe 'GET #edit' do
    let(:user) { create :user }
    let(:question) { create(:question) }

    before do
      sign_in_user(user)
      get :edit, params: { id: question.id }
    end

    it 'assings the requested question to @question' do
      expect(assigns(:question)).to eq question
    end

    it 'renders edit view' do
      expect(response).to render_template :edit
    end
  end

  describe 'POST #create' do
    let(:user) { create :user }

    before { sign_in_user(user) }

    context 'with valid attributes' do
      it 'saves the new question in the database' do
        expect { post :create, params: { question: attributes_for(:question) } }
          .to change(Question, :count).by(1)
      end

      it 'redirects to show view' do
        post :create, params: { question: attributes_for(:question) }
        expect(response).to redirect_to question_path(assigns(:question_form).question)
      end

      it 'the username of the created question is checked' do
        post :create, params: { question: attributes_for(:question) }
        expect(assigns(:question_form).user_id).to eq user.id
      end
    end

    context 'with invalid attributes' do
      it 'does not save the question' do
        expect { post :create, params: { question: attributes_for(:invalid_question) } }
          .not_to change(Question, :count)
      end

      it 're-renders new view' do
        post :create, params: { question: attributes_for(:invalid_question) }
        expect(response).to render_template :new
      end
    end
  end

  describe 'PATCH #update' do
    let(:user) { create :user }

    before { sign_in_user(user) }

    context 'when valid attributes' do
      let(:question) { create(:question, user: user) }

      it 'assings the requested question to @question' do
        patch :update, params: { id: question.id, question: attributes_for(:question) }
        expect(assigns(:question)).to eq question
      end

      it 'changes question attributes title' do
        patch :update, params: { id: question.id, question: { title: 'new title', body: 'new body' } }
        question.reload
        expect(question.title).to eq 'new title'
      end

      it 'changes question attributes body' do
        patch :update, params: { id: question.id, question: { title: 'new title', body: 'new body' } }
        question.reload
        expect(question.body).to eq 'new body'
      end

      it 'redirects to the update question' do
        patch :update, params: { id: question.id, question: attributes_for(:question) }
        expect(response).to redirect_to question
      end
    end

    context 'when edit invalid attributes' do
      let(:question) { create(:question, user: user) }

      before { patch :update, params: { id: question.id, question: { title: 'new title', body: nil } } }

      it 'does not change question attributes title' do
        question.reload
        expect(question.title).to eq 'MyString'
      end

      it 'does not change question attributes body' do
        question.reload
        expect(question.body).to eq 'MyText'
      end

      it 're-renders edit view' do
        expect(response).to redirect_to question_path
      end
    end

    context 'when user edit questions' do
      let(:question) { create(:question, user: user) }
      let(:user2) { create :user }
      let(:question2) { create(:question, user: user2) }

      before { sign_in_user(user2) }

      it 'author can change his question for attributes title' do
        patch :update, params: { id: question2.id, question: { title: 'new title', body: 'new body' } }
        question2.reload
        expect(question2.title).to eq 'new title'
      end

      it 'author can change his question for attributes body' do
        patch :update, params: { id: question2.id, question: { title: 'new title', body: 'new body' } }
        question2.reload
        expect(question2.body).to eq 'new body'
      end

      it 'author cannot change his own question for attributes title' do
        patch :update, params: { id: question.id, question: { title: 'new title', body: 'new body' } }
        question.reload
        expect(question.title).to eq 'MyString'
      end

      it 'author cannot change his own question for attributes body' do
        patch :update, params: { id: question.id, question: { title: 'new title', body: 'new body' } }
        question.reload
        expect(question.body).to eq 'MyText'
      end
    end
  end

  describe 'DELETE #destroy' do
    let(:user) { create :user }
    let(:question) { create(:question) }
    let(:answer) { create(:answer, question_id: question.id, user_id: user.id) }

    before do
      sign_in_user(user)
      create(:answer, question_id: question.id, user_id: user.id)
      create(:comment, commentable: question, user: user)
      create(:comment, commentable: question, user: user)
      create(:comment, commentable: answer, user: user)
      create(:comment, commentable: answer, user: user)
    end

    it 'deletes question' do
      question
      expect { delete :destroy, params: { id: question } }.to change(Question, :count).by(-1)
    end

    it 'redirect to index view' do
      delete :destroy, params: { id: question }
      expect(response).to redirect_to questions_path
    end

    it 'when you delete a question, all answers to the question are deleted' do
      expect { delete :destroy, params: { id: question } }.to change(Answer, :count).by(-2)
    end

    it 'when you delete a question, all comments to the question and answers are deleted' do
      expect { delete :destroy, params: { id: question } }.to change(Comment, :count).by(-4)
    end
  end
end
