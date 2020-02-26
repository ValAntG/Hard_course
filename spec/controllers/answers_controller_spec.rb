require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:user) { create :user }
  let(:question) { create :question }
  let(:answer) { create(:answer, question: question, user: user) }

  before { sign_in_user(user) }

  describe 'POST #create' do
    context 'with valid attributes' do
      let(:create_answer) do
        post :create, params: { answer: attributes_for(:answer), question_id: question, format: :json }
      end

      it { expect(create_answer).to be_successful }
      it { expect { create_answer }.to change(question.answers, :count).by(1) }
      it { expect(JSON.parse(create_answer.body)['answer']['body']).to eq('AnswerText') }
    end

    context 'with invalid attributes' do
      let(:create_answer) do
        post :create, params: { answer: attributes_for(:invalid_answer), question_id: question, format: :json }
      end

      it { expect(create_answer).to have_http_status(:unprocessable_entity) }
      it { expect { create_answer }.not_to change(question.answers, :count) }
      it { expect(JSON.parse(create_answer.body)['errors']).to eq('body' => ["can't be blank"]) }
    end
  end

  describe 'PATCH #update' do
    before do
      patch :update, params: { id: answer.id, question_id: question, answer: { body: 'new body' }, format: :js }
      answer.reload
    end

    it { expect(response).to be_successful }
    it { expect(assigns(:answer)).to eq answer }
    it { expect(assigns(:question)).to eq question }
    it { expect(answer.body).to eq 'new body' }
  end

  describe 'DELETE #destroy' do
    let(:delete_answer) { delete :destroy, params: { id: answer, question_id: question } }

    before do
      sign_in_user(user)
      answer
    end

    it { expect { delete_answer }.to change(Answer, :count).by(-1) }
    it { expect(delete_answer).to redirect_to question_path(question.id) }
  end
end
