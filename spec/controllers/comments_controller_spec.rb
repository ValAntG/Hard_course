require 'rails_helper'

RSpec.describe CommentsController, type: :controller do
  let(:user) { create :user }
  let(:question) { create :question }
  let(:answer) { create(:answer, question: question, user: user) }

  before { sign_in_user(user) }

  describe 'POST #create' do
    describe 'with valid attributes comment for question' do
      subject(:post_create) { post :create, params: { comment: attr, question_id: question }, format: :json }

      let(:attr) { attributes_for(:comment, :for_question, question_id: question, commentable_id: question) }

      it { expect { post_create }.to change(question.comments, :count).by(1) }
      it { expect(JSON.parse(post_create.body)['body']).to eq(attributes_for(:comment)[:body]) }
    end

    describe 'with valid attributes comment for answer' do
      subject(:post_create) { post :create, params: { comment: attr, answer_id: answer }, format: :json }

      let(:attr) { attributes_for(:comment, :for_answer, question_id: question, commentable_id: answer) }

      it { expect { post_create }.to change(answer.comments, :count).by(1) }
      it { expect(JSON.parse(post_create.body)['body']).to eq(attributes_for(:comment)[:body]) }
    end

    describe 'invalid attributes for question' do
      subject(:post_create) { post :create, params: { comment: attr, question_id: question }, format: :json }

      let(:attr) { attributes_for(:comment, :invalid, :for_question, question_id: question, commentable_id: question) }

      it { expect(post_create).to have_http_status(:unprocessable_entity) }
      it { expect { post_create }.not_to change(question.comments, :count) }
      it { expect(JSON.parse(post_create.body)['errors']).to eq('body' => ["can't be blank"]) }
    end

    describe 'invalid attributes for answer' do
      subject(:post_create) { post :create, params: { comment: attr, answer_id: answer }, format: :json }

      let(:attr) { attributes_for(:comment, :invalid, :for_answer, question_id: question, commentable_id: answer) }

      it { expect(post_create).to have_http_status(:unprocessable_entity) }
      it { expect { post_create }.not_to change(answer.comments, :count) }
      it { expect(JSON.parse(post_create.body)['errors']).to eq('body' => ["can't be blank"]) }
    end
  end

  describe 'PATCH #update' do
    context 'with valid attributes for question' do
      let(:comment) { create(:comment, commentable: question, user: user) }
      let(:attr) { attributes_for(:comment, :new, :for_question, question_id: question, commentable_id: question) }

      before do
        patch :update, params: { comment: attr, id: comment }, format: :json
        comment.reload
      end

      it { expect(assigns(:comment)).to eq comment }
      it { expect(comment.body).to eq(attributes_for(:comment, :new)[:body]) }
    end

    context 'with valid attributes for answer' do
      let(:comment) { create(:comment, commentable: answer, user: user) }
      let(:attr) { attributes_for(:comment, :new, :for_answer, question_id: question, commentable_id: answer) }

      before do
        patch :update, params: { comment: attr, id: comment }, format: :json
        comment.reload
      end

      it { expect(assigns(:comment)).to eq comment }
      it { expect(comment.body).to eq(attributes_for(:comment, :new)[:body]) }

      it 'render update template' do
        patch :update, params: { comment: attr, id: comment }, format: :html
        expect(response).to redirect_to question_path(question.id)
      end
    end
  end

  describe 'DELETE #destroy' do
    before { sign_in_user(user) }

    context 'with delete comment for question' do
      subject(:delete_comment) { delete :destroy, params: { id: comment, comment: { question_id: question } } }

      let(:comment) { create(:comment, commentable: question, user: user) }

      before { comment }

      it { expect(delete_comment).to redirect_to question_path(question.id) }
      it { expect { delete_comment }.to change(Comment, :count).by(-1) }
    end

    context 'with delete comment for answer' do
      subject(:delete_comment) do
        delete :destroy, params: { id: comment, comment: { question_id: question }, answer_id: answer }
      end

      let(:comment) { create(:comment, commentable: answer, user: user) }

      before { comment }

      it { expect(delete_comment).to redirect_to question_path(question.id) }
      it { expect { delete_comment }.to change(Comment, :count).by(-1) }
    end
  end
end
