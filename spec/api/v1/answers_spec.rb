require 'rails_helper'

describe 'Answer API' do
  let(:question) { create :question }
  let(:user) { create :user }
  let(:access_token) { create(:access_token) }
  let!(:answer) { create(:answer, question: question, user: user) }

  describe 'GET /index' do
    it_behaves_like 'API Authenticable'

    context 'when authorized' do
      before do
        create(:answer, question: question, user: user)
        get "/api/v1/questions/#{question.id}/answers", params: { format: :json, access_token: access_token.token }
      end

      it { expect(response).to be_successful }
      it { expect(response.body).to have_json_size(2) }

      %w[id body created_at updated_at].each do |attr|
        it { expect(response.body).to be_json_eql(answer.send(attr.to_sym).to_json).at_path("0/#{attr}") }
      end
    end

    context 'when authorized invalid path' do
      subject(:parsed_response) { JSON.parse(response.body) }

      before do
        create(:answer, question: question, user: user)
        get "/api/v1/questions/#{question.id + 2}/answers", params: { format: :json, access_token: access_token.token }
      end

      it { expect(parsed_response['status']).to eq('error') }
      it { expect(parsed_response['code']).to eq(404) }
      it { expect(parsed_response['message']).to eq("Can't find question") }
    end

    def do_request(options = {})
      get "/api/v1/questions/#{question.id}/answers", params: { format: :json }.merge(options)
    end
  end

  describe 'GET /show' do
    it_behaves_like 'API Authenticable'

    context 'when authorized' do
      let!(:comment) { create(:comment, commentable: answer, user: user) }

      before { get "/api/v1/answers/#{answer.id}", params: { format: :json, access_token: access_token.token } }

      it { expect(response).to be_successful }

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

    context 'when authorized invalid path' do
      subject(:parsed_response) { JSON.parse(response.body) }

      before do
        get "/api/v1/questions/#{question.id + 2}/answers", params: { format: :json, access_token: access_token.token }
      end

      it { expect(parsed_response['status']).to eq('error') }
      it { expect(parsed_response['code']).to eq(404) }
      it { expect(parsed_response['message']).to eq("Can't find question") }
    end

    def do_request(options = {})
      get "/api/v1/answers/#{answer.id}", params: { format: :json }.merge(options)
    end
  end

  describe 'POST #create' do
    subject(:post_create) { post "/api/v1/questions/#{question.id}/answers", params: params }

    it_behaves_like 'API Authenticable'

    context 'with valid attributes' do
      subject(:params) { { answer: attributes_for(:answer), format: :json, access_token: access_token.token } }

      before { post "/api/v1/questions/#{question.id}/answers", params: params }

      it { expect(response).to be_successful }
      it { expect { post_create }.to change(Answer, :count).by(1) }
      it { expect(Answer.last.user_id).to eq(access_token.resource_owner_id) }
      it { expect(Answer.last.body).to eq(attributes_for(:answer)[:body]) }
    end

    context 'with invalid attributes' do
      subject(:params) do
        { answer: attributes_for(:answer, :invalid), format: :json, access_token: access_token.token }
      end

      before { post "/api/v1/questions/#{question.id}/answers", params: params }

      it { expect { post_create }.not_to change(Answer, :count) }
      it { expect(response).not_to be_successful }
      it { expect(response.status).to eq 422 }
    end

    def do_request(options = {})
      get "/api/v1/answers/#{answer.id}", params: { format: :json }.merge(options)
    end
  end
end
