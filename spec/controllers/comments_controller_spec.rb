require 'rails_helper'

RSpec.describe CommentsController, type: :controller do
  let(:user) { create :user }
  let(:question) { create :question }

  before { sign_in_user(user) }

  describe 'POST #create' do
    describe 'with valid attributes comment for question' do
      let(:params) do
        { comment: {
          body: 'MyComment',
          question_id: question.id,
          commentable_type: 'Question',
          commentable_id: question.id
        },
          question_id: question.id }
      end

      it 'successful response received' do
        expect(response).to be_successful
      end

      it 'saves the new comment in the database, send format: json' do
        expect { post :create, params: params, format: :json }.to change(question.comments, :count).by(1)
      end

      context 'with valid attributes comment for question after send' do
        before { post :create, params: params, format: :json }

        it 'and render create template, send format: json' do
          parsed_response = JSON.parse(response.body)
          expect(parsed_response['body']).to eq('MyComment')
        end
      end
    end

    describe 'with valid attributes comment for answer' do
      let(:answer) { create(:answer, question: question, user: user) }
      let(:params) do
        { comment: {
          body: 'MyComment',
          question_id: question.id,
          commentable_type: 'Answer',
          commentable_id: answer.id
        },
          answer_id: answer.id }
      end

      it 'successful response received' do
        expect(response).to be_successful
      end

      it 'saves the new comment in the database, send format: json' do
        expect { post :create, params: params, format: :json }.to change(answer.comments, :count).by(1)
      end

      context 'with valid attributes comment for answer after send ' do
        before { post :create, params: params, format: :json }

        it 'and render create template, send format: json' do
          parsed_response = JSON.parse(response.body)
          expect(parsed_response['body']).to eq('MyComment')
        end
      end
    end

    describe 'invalid attributes for question' do
      let(:invalid_params) do
        { comment: {
          body: nil,
          question_id: question.id,
          commentable_type: 'Question',
          commentable_id: question.id
        },
          question_id: question.id }
      end

      it 'does not save the comment, send format: json' do
        expect { post :create, params: invalid_params, format: :json }.not_to change(question.comments, :count)
      end

      it 'redirects to question show view, send format: json' do
        post :create, params: invalid_params, format: :json
        parsed_response = JSON.parse(response.body)['errors']
        expect(parsed_response).to eq('body' => ["can't be blank"])
      end

      it 'unprocessable entity response received' do
        post :create, params: invalid_params, format: :json
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end

    describe 'invalid attributes for answer' do
      let(:answer) { create(:answer, question: question, user: user) }
      let(:invalid_params) do
        { comment: {
          body: nil,
          question_id: question.id,
          commentable_type: 'Answer',
          commentable_id: answer.id
        },
          answer_id: answer.id }
      end

      it 'does not save the comment, send format: json' do
        expect { post :create, params: invalid_params, format: :json }.not_to change(answer.comments, :count)
      end

      it 'redirects to question show view, send format: json' do
        post :create, params: invalid_params, format: :json
        parsed_response = JSON.parse(response.body)['errors']
        expect(parsed_response).to eq('body' => ["can't be blank"])
      end

      it 'unprocessable entity response received' do
        post :create, params: invalid_params, format: :json
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe 'PATCH #update' do
    context 'with valid attributes for question' do
      let(:comment) { create(:comment, commentable: question, user: user) }
      let(:params) do
        { comment: {
          body: 'new body',
          question_id: question.id,
          commentable_type: 'Question',
          commentable_id: question.id
        },
          id: comment.id }
      end

      it 'assings the requested comment' do
        patch :update, params: params, format: :json
        expect(assigns(:comment)).to eq comment
      end

      it 'changes comment attributes' do
        patch :update, params: params, format: :json
        comment.reload
        expect(comment.body).to eq 'new body'
      end
    end

    context 'with valid attributes for answer' do
      let(:answer) { create(:answer, question: question, user: user) }
      let(:comment) { create(:comment, commentable: answer, user: user) }
      let(:params) do
        { comment: {
          body: 'new body',
          question_id: question.id,
          commentable_type: 'Answer',
          commentable_id: answer.id
        },
          id: comment.id }
      end

      it 'assings the requested comment' do
        patch :update, params: params, format: :json
        expect(assigns(:comment)).to eq comment
      end

      it 'changes comment attributes' do
        patch :update, params: params, format: :json
        comment.reload
        expect(comment.body).to eq 'new body'
      end

      it 'render update template' do
        patch :update, params: params, format: :html
        expect(response).to redirect_to question_path(question.id)
      end
    end
  end

  describe 'DELETE #destroy' do
    let(:user) { create :user }
    let(:question) { create(:question) }

    before { sign_in_user(user) }

    context 'with delete comment for question' do
      let(:comment) { create(:comment, commentable: question, user: user) }

      it 'deletes comment' do
        comment
        expect { delete :destroy, params: { id: comment.id, comment: { question_id: question.id } } }
          .to change(Comment, :count).by(-1)
      end

      it 'redirect to index view' do
        delete :destroy, params: { id: comment.id, comment: { question_id: question.id } }
        expect(response).to redirect_to question_path(question.id)
      end
    end

    context 'with delete comment for answer' do
      let(:question) { create(:question) }
      let(:answer) { create(:answer, question: question, user: user) }
      let(:comment) { create(:comment, commentable: answer, user: user) }

      it 'deletes comment' do
        comment
        expect do
          delete :destroy, params: { id: comment.id, comment: { question_id: question.id }, answer_id: answer.id }
        end
          .to change(Comment, :count).by(-1)
      end

      it 'redirect to index view' do
        delete :destroy, params: { id: comment.id, comment: { question_id: question.id }, answer_id: answer.id }
        expect(response).to redirect_to question_path(question.id)
      end
    end
  end
end
