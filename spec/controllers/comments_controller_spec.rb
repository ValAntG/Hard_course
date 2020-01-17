require 'rails_helper'

RSpec.describe CommentsController, type: :controller do
  let!(:user) { create :user }
  before { sign_in_user(user) }
  let!(:question) { create :question }

  describe 'POST #create' do
    context 'with valid attributes comment for question' do
      it 'saves the new comment in the database, send format: html' do
        expect(response).to be_success
        expect { post :create, params: { comment: attributes_for(:comment), question_id: question, format: :html } }
          .to change(question.comments, :count).by(1)
      end

      it 'saves the new comment in the database, send format: json' do
        expect(response).to be_success
        expect { post :create, params: { comment: attributes_for(:comment), question_id: question, format: :json } }
          .to change(question.comments, :count).by(1)
      end

      it 'render create template, send format: html' do
        post :create, params: { comment: attributes_for(:comment), question_id: question, format: :html }
        expect(response).to render_template(partial: 'questions/_comments_show')
      end

      it 'render create template, send format: json' do
        post :create, params: { comment: attributes_for(:comment), question_id: question, format: :json }
        expect(response).to be_success
        parsed_response = JSON.parse(response.body)
        expect(parsed_response['comment']['body']).to eq('MyComment')
      end
    end

    context 'with valid attributes comment for answer' do
      let!(:answer) { create(:answer, question: question, user: user) }
      it 'saves the new comment in the database, send format: html' do
        expect(response).to be_success
        expect do
          post :create, params: { comment: attributes_for(:comment), question_id: question, answer_id: answer,
                                  format: :html }
        end
          .to change(answer.comments, :count).by(1)
      end

      it 'saves the new comment in the database, send format: json' do
        expect(response).to be_success
        expect do
          post :create, params: { comment: attributes_for(:comment), question_id: question, answer_id: answer,
                                  format: :json }
        end
          .to change(answer.comments, :count).by(1)
      end

      it 'render create template comment for answer, send format: html' do
        post :create, params: { comment: attributes_for(:comment), question_id: question, answer_id: answer,
                                format: :html }
        expect(response).to render_template(partial: 'questions/_comments_show')
      end

      it 'render create template, send format: json' do
        post :create, params: { comment: attributes_for(:comment), question_id: question, answer_id: answer,
                                format: :json }
        expect(response).to be_success
        parsed_response = JSON.parse(response.body)
        expect(parsed_response['comment']['body']).to eq('MyComment')
      end
    end

    context 'with invalid attributes for question' do
      it 'does not save the comment, send format: html' do
        expect do
          post :create, params: { comment: attributes_for(:invalid_comment), question_id: question, format: :html }
        end
          .to_not change(question.comments, :count)
      end

      it 'does not save the comment, send format: json' do
        expect do
          post :create, params: { comment: attributes_for(:invalid_comment), question_id: question, format: :json }
        end
          .to_not change(question.comments, :count)
      end

      it 'redirects to question show view, send format: html' do
        post :create, params: { comment: attributes_for(:invalid_comment), question_id: question, format: :html }
        expect(response).to_not render_template(partial: 'questions/_comment_show')
      end

      it 'redirects to question show view, send format: json' do
        post :create, params: { comment: attributes_for(:invalid_comment), question_id: question, format: :json }
        expect(response).to have_http_status(422)
        parsed_response = JSON.parse(response.body)
        expect(parsed_response.first).to eq("Body can't be blank")
      end
    end

    context 'with invalid attributes for answer' do
      let!(:answer) { create(:answer, question: question, user: user) }
      it 'does not save the comment, send format: html' do
        expect do
          post :create, params: { comment: attributes_for(:invalid_comment), question_id: question, answer_id: answer,
                                  format: :html }
        end
          .to_not change(answer.comments, :count)
      end

      it 'does not save the comment, send format: json' do
        expect do
          post :create, params: { comment: attributes_for(:invalid_comment), question_id: question, answer_id: answer,
                                  format: :json }
        end
          .to_not change(answer.comments, :count)
      end

      it 'redirects to question show view, send format: html' do
        post :create, params: { comment: attributes_for(:invalid_comment), question_id: question, answer_id: answer,
                                format: :html }
        expect(response).to_not render_template(partial: 'questions/_comment_show')
      end

      it 'redirects to question show view, send format: json' do
        post :create, params: { comment: attributes_for(:invalid_comment), question_id: question, answer_id: answer,
                                format: :json }
        expect(response).to have_http_status(422)
        parsed_response = JSON.parse(response.body)
        expect(parsed_response.first).to eq("Body can't be blank")
      end
    end
  end

  describe 'PATCH #update' do
    context 'with valid attributes for question' do
      let(:comment) { create(:comment, commentable: question, user: user) }
      it 'assings the requested comment' do
        patch :update, params: { id: comment.id, question_id: question.id, comment: attributes_for(:comment),
                                 format: :js }
        expect(assigns(:comment)).to eq comment
      end

      it 'changes comment attributes' do
        patch :update, params: { id: comment.id, question_id: question.id, comment: { body: 'new body' }, format: :js }
        comment.reload
        expect(comment.body).to eq 'new body'
      end

      it 'render update template' do
        patch :update, params: { id: comment.id, question_id: question.id, comment: { body: 'new body' }, format: :js }
        expect(response).to redirect_to question_path(question.id)
      end
    end

    context 'with valid attributes for answer' do
      let!(:answer) { create(:answer, question: question, user: user) }
      let(:comment) { create(:comment, commentable: answer, user: user) }
      it 'assings the requested comment' do
        patch :update, params: { id: comment.id, question_id: question.id, answer_id: answer,
                                 comment: attributes_for(:comment), format: :js }
        expect(assigns(:comment)).to eq comment
      end

      it 'changes comment attributes' do
        patch :update, params: { id: comment.id, question_id: question.id, answer_id: answer,
                                 comment: { body: 'new body' }, format: :js }
        comment.reload
        expect(comment.body).to eq 'new body'
      end

      it 'render update template' do
        patch :update, params: { id: comment.id, question_id: question.id, answer_id: answer,
                                 comment: { body: 'new body' }, format: :js }
        expect(response).to redirect_to question_path(question.id)
      end
    end
  end

  describe 'DELETE #destroy' do
    let!(:user) { create :user }
    before { sign_in_user(user) }
    let(:question) { create(:question) }

    context 'with delete comment for question' do
      let(:comment) { create(:comment, commentable: question, user: user) }
      it 'deletes comment' do
        comment
        expect { delete :destroy, params: { id: comment.id, question_id: question.id } }
          .to change(Comment, :count).by(-1)
      end

      it 'redirect to index view' do
        delete :destroy, params: { id: comment.id, question_id: question.id }
        expect(response).to redirect_to question_path(question.id)
      end
    end

    context 'with delete comment for answer' do
      let(:question) { create(:question) }
      let!(:answer) { create(:answer, question: question, user: user) }
      let(:comment) { create(:comment, commentable: answer, user: user) }
      it 'deletes comment' do
        comment
        expect { delete :destroy, params: { id: comment.id, question_id: question.id, answer_id: answer.id } }
          .to change(Comment, :count).by(-1)
      end

      it 'redirect to index view' do
        delete :destroy, params: { id: comment.id, question_id: question.id, answer_id: answer.id }
        expect(response).to redirect_to question_path(question.id)
      end
    end
  end
end
