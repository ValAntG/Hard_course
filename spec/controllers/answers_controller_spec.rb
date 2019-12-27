require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let!(:user) { create :user }
  before { sign_in_user(user) }
  let!(:question) { create :question }

  describe 'POST #create' do
    context 'with valid attributes' do
      it 'saves the new answer in the database, send format: html' do
        expect(response).to be_success
        expect { post :create, params: { answer: attributes_for(:answer), question_id: question, format: :html } }
          .to change(question.answers, :count).by(1)
      end

      it 'saves the new answer in the database, send format: json' do
        expect(response).to be_success
        expect { post :create, params: { answer: attributes_for(:answer), question_id: question, format: :json } }
          .to change(question.answers, :count).by(1)
      end

      it 'render create template, send format: html' do
        post :create, params: { answer: attributes_for(:answer), question_id: question, format: :html }
        expect(response).to render_template(partial: 'questions/_answers_show')
      end

      it 'render create template, send format: json' do
        post :create, params: { answer: attributes_for(:answer), question_id: question, format: :json }
        expect(response).to be_success
        parsed_response = JSON.parse(response.body)
        expect(parsed_response['answer']['body']).to eq('AnswerText')
      end
    end

    context 'with invalid attributes' do
      it 'does not save the answer, send format: html' do
        expect do
          post :create, params: { answer: attributes_for(:invalid_answer), question_id: question, format: :html }
        end
          .to_not change(question.answers, :count)
      end

      it 'does not save the answer, send format: json' do
        expect do
          post :create, params: { answer: attributes_for(:invalid_answer), question_id: question, format: :json }
        end
          .to_not change(question.answers, :count)
      end

      it 'redirects to question show view, send format: html' do
        post :create, params: { answer: attributes_for(:invalid_answer), question_id: question, format: :html }
        expect(response).to_not render_template(partial: 'questions/_answers_show')
      end

      it 'redirects to question show view, send format: json' do
        post :create, params: { answer: attributes_for(:invalid_answer), question_id: question, format: :json }
        expect(response).to have_http_status(422)
        parsed_response = JSON.parse(response.body)
        expect(parsed_response.first).to eq("Body can't be blank")
      end
    end
  end

  describe 'PATCH #update' do
    let(:answer) { create(:answer, question: question, user: user) }
    it 'assings the requested answer to @answer' do
      patch :update, params: { id: answer.id, question_id: question.id, answer: attributes_for(:answer), format: :js }
      expect(assigns(:answer)).to eq answer
    end

    it 'assings the question' do
      patch :update, params: { id: answer.id, question_id: question.id, answer: attributes_for(:answer), format: :js }
      expect(assigns(:question)).to eq question
    end

    it 'changes answer attributes' do
      patch :update, params: { id: answer.id, question_id: question.id, answer: { body: 'new body' }, format: :js }
      answer.reload
      expect(answer.body).to eq 'new body'
    end

    it 'render update template' do
      patch :update, params: { id: answer.id, question_id: question.id, answer: attributes_for(:answer), format: :js }
      expect(response).to redirect_to question_path(question.id)
    end
  end

  describe 'DELETE #destroy' do
    let!(:user) { create :user }
    before { sign_in_user(user) }
    let(:question) { create(:question) }
    let(:answer) { create(:answer, question: question, user: user) }
    it 'deletes answer' do
      answer
      expect { delete :destroy, params: { id: answer.id, question_id: question.id } }
        .to change(Answer, :count).by(-1)
    end

    it 'redirect to index view' do
      delete :destroy, params: { id: answer, question_id: question.id }
      expect(response).to redirect_to question_path(question.id)
    end
  end
end
