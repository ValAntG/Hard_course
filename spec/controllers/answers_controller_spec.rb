require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:user) { create :user }
  let(:question) { create :question }

  before { sign_in_user(user) }

  describe 'POST #create' do
    context 'with valid attributes after send' do
      it 'successful response received' do
        expect(response).to be_successful
      end

      it 'saves the new answer in the database, send format: json' do
        expect { post :create, params: { answer: attributes_for(:answer), question_id: question, format: :json } }
          .to change(question.answers, :count).by(1)
      end
    end

    context 'with valid attributes after send' do
      before { post :create, params: { answer: attributes_for(:answer), question_id: question, format: :json } }

      it 'with render create template send format: json' do
        expect(response).to be_successful
      end

      it 'with render create template, parsed response, send format: json' do
        parsed_response = JSON.parse(response.body)
        expect(parsed_response['answer']['body']).to eq('AnswerText')
      end
    end

    describe 'with invalid attributes' do
      it 'does not save the answer, send format: json' do
        expect do
          post :create, params: { answer: attributes_for(:invalid_answer), question_id: question, format: :json }
        end
          .not_to change(question.answers, :count)
      end
    end

    describe 'with invalid attributes after send' do
      before { post :create, params: { answer: attributes_for(:invalid_answer), question_id: question, format: :json } }

      it 'redirects to question show view send format: json' do
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it 'redirects to question show view, parsed response, send format: json' do
        parsed_response = JSON.parse(response.body)['errors']
        expect(parsed_response).to eq('body' => ["can't be blank"])
      end
    end
  end

  describe 'PATCH #update' do
    let(:answer) { create(:answer, question: question, user: user) }

    it 'successful response received' do
      expect(response).to be_successful
    end

    context 'when send format: :js' do
      before do
        patch :update, params: { id: answer.id, question_id: question.id, answer: { body: 'new body' }, format: :js }
      end

      it 'assings the requested answer to @answer' do
        expect(assigns(:answer)).to eq answer
      end

      it 'assings the question' do
        expect(assigns(:question)).to eq question
      end

      it 'changes answer attributes' do
        answer.reload
        expect(answer.body).to eq 'new body'
      end
    end
  end

  describe 'DELETE #destroy' do
    let(:user) { create :user }
    let(:question) { create(:question) }
    let(:answer) { create(:answer, question_id: question.id, user_id: user.id) }

    before { sign_in_user(user) }

    context 'when the answer is deleted' do
      before { answer }

      it 'decreases in the database' do
        expect { delete :destroy, params: { id: answer.id, question_id: question.id } }.to change(Answer, :count).by(-1)
      end
    end

    context 'when the answer is deleted redirect to index view' do
      before { delete :destroy, params: { id: answer, question_id: question.id } }

      it { expect(response).to redirect_to question_path(question.id) }
    end
  end
end
