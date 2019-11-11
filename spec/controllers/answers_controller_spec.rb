require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  describe 'POST #create' do
    sign_in_user
    let (:question) { create :question }
    context 'with valid attributes' do
      it 'saves the new answer in the database' do
        expect { post :create, params: { answer: attributes_for(:answer), question_id: question } }
          .to change(question.answers, :count).by(1)
      end

      it 'redirects to question show view' do
        post :create, params: { answer: attributes_for(:answer), question_id: question }
        expect(response).to redirect_to question_path(question)
      end
    end

    context 'with invalid attributes' do
      it 'does not save the answer' do
        expect { post :create, params: { answer: attributes_for(:invalid_answer), question_id: question } }
          .to_not change(question.answers, :count)
      end

      it 'redirects to question show view' do
        post :create, params: { answer: attributes_for(:invalid_answer), question_id: question }
        expect(response).to redirect_to question_path(question)
      end
    end
  end
end
