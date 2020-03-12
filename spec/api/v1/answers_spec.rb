require 'rails_helper'

describe 'Answer API' do
  let(:question) { create :question }
  let(:user) { create :user }
  let(:access_token) { create(:access_token) }
  let!(:answer) { create(:answer, question: question, user: user) }

  describe 'GET /index' do
    let!(:answer2) { create(:answer, question: question, user: user) }

    context 'when unauthorized' do
      it 'return 401 status if there is no access_token' do
        get "/api/v1/questions/#{question.id}/answers", params: { format: :json }
        expect(response.status).to eq 401
      end

      it 'return 401 status if access_token is valid' do
        get "/api/v1/questions/#{question.id}/answers", params: { format: :json, access_token: '1234' }
        expect(response.status).to eq 401
      end
    end

    context 'when authorized' do
      before do
        get "/api/v1/questions/#{question.id}/answers", params: { format: :json, access_token: access_token.token }
      end

      it { expect(response).to be_success }
      it { expect(response.body).to have_json_size(2) }

      %w[id body created_at updated_at].each do |attr|
        it { expect(response.body).to be_json_eql(answer.send(attr.to_sym).to_json).at_path("0/#{attr}") }
      end
    end
  end

  describe 'GET /show' do
    context 'when unauthorized' do
      it 'return 401 status if there is no access_token' do
        get "/api/v1/answers/#{answer.id}", params: { format: :json }
        expect(response.status).to eq 401
      end

      it 'return 401 status if access_token is valid' do
        get "/api/v1/answers/#{answer.id}", params: { format: :json, access_token: '1234' }
        expect(response.status).to eq 401
      end
    end

    context 'when authorized' do
      let!(:comment) { create(:comment, commentable: answer, user: user) }

      before { get "/api/v1/answers/#{answer.id}", params: { format: :json, access_token: access_token.token } }

      it { expect(response).to be_success }

      %w[id body created_at updated_at].each do |attr|
        it { expect(response.body).to be_json_eql(answer.send(attr.to_sym).to_json).at_path(attr.to_s) }
      end

      context 'with comment' do
        it { expect(response.body).to have_json_size(1).at_path('comments') }

        %w[id body created_at updated_at].each do |attr|
          it { expect(response.body).to be_json_eql(comment.send(attr.to_sym).to_json).at_path("comments/0/#{attr}") }
        end
      end
    end
  end

  describe 'POST #create' do
    subject(:post_create) { post "/api/v1/questions/#{question.id}/answers", params: params }

    before { post "/api/v1/questions/#{question.id}/answers", params: params }

    context 'when unauthorized return 401 status if there is no access_token' do
      subject(:params) { { format: :json } }

      it { expect(response.status).to eq 401 }
    end

    context 'when unauthorized return 401 status if access_token is valid' do
      subject(:params) { { format: :json, access_token: '1234' } }

      it { expect(response.status).to eq 401 }
    end

    context 'with valid attributes' do
      subject(:params) { { answer: attributes_for(:answer), format: :json, access_token: access_token.token } }

      it { expect(response).to be_success }
      it { expect { post_create }.to change(Answer, :count).by(1) }
      it { expect(Answer.last.user_id).to eq(access_token.resource_owner_id) }
      it { expect(Answer.last.body).to eq(attributes_for(:answer)[:body]) }
    end

    # context 'with invalid attributes' do
    #   subject(:params) do
    #     { question: attributes_for(:question, :invalid), format: :json, access_token: access_token.token }
    #   end
    #
    #   it { expect { post_create }.not_to change(Question, :count) }
    #   it { expect(response).not_to be_success }
    #   it { expect(response.status).to eq 422 }
    # end
    #
    # context 'with invalid title' do
    #   subject(:params) do
    #     { question: attributes_for(:question, :invalid_title), format: :json, access_token: access_token.token }
    #   end
    #
    #   it { expect { post_create }.not_to change(Question, :count) }
    #   it { expect(response).not_to be_success }
    #   it { expect(response.status).to eq 422 }
    # end
    #
    # context 'with invalid body' do
    #   subject(:params) do
    #     { question: attributes_for(:question, :invalid_body), format: :json, access_token: access_token.token }
    #   end
    #
    #   it { expect { post_create }.not_to change(Question, :count) }
    #   it { expect(response).not_to be_success }
    #   it { expect(response.status).to eq 422 }
    # end
  end
end
