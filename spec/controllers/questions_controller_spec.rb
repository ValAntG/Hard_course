# frozen_string_literal: true

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
  end

  describe 'GET #new' do
    let!(:user) { create :user }
    before { sign_in_user(user) }
    before { get :new }

    it 'assings a new Question to @question' do
      expect(assigns(:question)).to be_a_new(Question)
    end

    it 'renders new view' do
      expect(response).to render_template :new
    end
  end

  describe 'GET #edit' do
    let!(:user) { create :user }
    before { sign_in_user(user) }
    let(:question) { create(:question) }

    before { get :edit, params: { id: question.id } }

    it 'assings the requested question to @question' do
      expect(assigns(:question)).to eq question
    end

    it 'renders edit view' do
      expect(response).to render_template :edit
    end
  end

  describe 'POST #create' do
    let!(:user) { create :user }
    before { sign_in_user(user) }

    context 'with valid attributes' do
      it 'saves the new question in the database' do
        expect { post :create, params: { question: attributes_for(:question) } }
          .to change(Question, :count).by(1)
      end

      it 'redirects to show view' do
        post :create, params: { question: attributes_for(:question) }
        expect(response).to redirect_to question_path(assigns(:question))
      end

      it 'the username of the created question is checked' do
        post :create, params: { question: attributes_for(:question) }
        # binding.pry
        expect(assigns(:question).user).to eq user
        # expect(question.user).to eq user
      end
    end

    context 'with invalid attributes' do
      it 'does not save the question' do
        expect { post :create, params: { question: attributes_for(:invalid_question) } }
          .to_not change(Question, :count)
      end

      it 're-renders new view' do
        post :create, params: { question: attributes_for(:invalid_question) }
        expect(response).to render_template :new
      end
    end
  end

  describe 'PATCH #update' do
    let!(:user) { create :user }
    before { sign_in_user(user) }
    context 'valid attributes' do
      let(:question) { create(:question) }
      it 'assings the requested question to @question' do
        patch :update, params: { id: question.id, question: attributes_for(:question) }
        expect(assigns(:question)).to eq question
      end

      it 'changes question attributes' do
        patch :update, params: { id: question.id, question: { title: 'new title', body: 'new body' } }
        question.reload
        expect(question.title).to eq 'new title'
        expect(question.body).to eq 'new body'
      end

      it 'redirects to the update question' do
        patch :update, params: { id: question.id, question: attributes_for(:question) }
        expect(response).to redirect_to question
      end
    end

    context 'invalid attributes' do
      let(:question) { create(:question) }
      before { patch :update, params: { id: question.id, question: { title: 'new title', body: nil } } }

      it 'does not change question attributes' do
        question.reload
        expect(question.title).to eq 'MyString'
        expect(question.body).to eq 'MyText'
      end

      it 're-renders edit view' do
        expect(response).to render_template :edit
      end
    end
  end

  describe 'DELETE #destroy' do
    let!(:user) { create :user }
    before { sign_in_user(user) }
    let(:question) { create(:question) }
    it 'deletes question' do
      question
      expect { delete :destroy, params: { id: question } }
        .to change(Question, :count).by(-1)
    end

    it 'redirect to index view' do
      delete :destroy, params: { id: question }
      expect(response).to redirect_to question_path
    end
  end
end
