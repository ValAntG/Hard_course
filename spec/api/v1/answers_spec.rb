require 'rails_helper'

describe 'Answer API' do
  let(:question) { create :question }
  let(:user) { create :user }
  let(:access_token) { create(:access_token) }
  let!(:answer) { create(:answer, question: question, user: user) }

  describe 'GET /index' do
    let(:invalid_path) do
      get "/api/v1/questions/#{question.id + 2}/answers", params: { format: :json, access_token: access_token.token }
    end

    let(:index_authorized) do
      create(:answer, question: question, user: user)
      get "/api/v1/questions/#{question.id}/answers", params: { format: :json, access_token: access_token.token }
    end

    it_behaves_like 'API Authenticable'
    it_behaves_like 'API show invalid path'

    it_behaves_like 'API index when authorized', %w[id body created_at updated_at] do
      let(:object) { answer }
      let(:size) { 2 }
      let(:have_json_at_path) { nil }
      let(:path) { '0/' }
    end

    def do_request(options = {})
      get "/api/v1/questions/#{question.id}/answers", params: { format: :json }.merge(options)
    end
  end

  describe 'GET /show' do
    let!(:comment) { create(:comment, commentable: answer, user: user) }

    let(:invalid_path) do
      get "/api/v1/questions/#{question.id + 2}/answers", params: { format: :json, access_token: access_token.token }
    end

    let(:index_authorized) do
      get "/api/v1/answers/#{answer.id}", params: { format: :json, access_token: access_token.token }
    end

    it_behaves_like 'API Authenticable'
    it_behaves_like 'API show invalid path'

    it_behaves_like 'API index when authorized', %w[id body created_at updated_at] do
      let(:object) { answer }
      let(:size) { 7 }
      let(:have_json_at_path) { nil }
      let(:path) { '' }
    end

    it_behaves_like 'API index when authorized', %w[id body created_at updated_at] do
      let(:object) { comment }
      let(:size) { 1 }
      let(:have_json_at_path) { 'comments' }
      let(:path) { 'comments/0/' }
    end

    it_behaves_like 'API index when authorized', %w[id body created_at updated_at] do
      let(:object) { answer }
      let(:size) { 0 }
      let(:have_json_at_path) { 'attachments' }
      let(:path) { '' }
    end

    def do_request(options = {})
      get "/api/v1/answers/#{answer.id}", params: { format: :json }.merge(options)
    end
  end

  describe 'POST #create' do
    let(:object) { Answer }

    it_behaves_like 'API Authenticable'

    it_behaves_like 'API create invalid attributes' do
      let(:attributes) { attributes_for(:answer, :invalid) }
    end

    context 'with valid attributes' do
      subject(:post_create) { post "/api/v1/questions/#{question.id}/answers", params: params }

      let(:params) { { answer: attributes_for(:answer), format: :json, access_token: access_token.token } }

      before { post "/api/v1/questions/#{question.id}/answers", params: params }

      it { expect(response).to be_successful }
      it { expect { post_create }.to change(Answer, :count).by(1) }
      it { expect(Answer.last.user_id).to eq(access_token.resource_owner_id) }
      it { expect(Answer.last.body).to eq(attributes_for(:answer)[:body]) }
    end

    def do_request(options = {})
      get "/api/v1/answers/#{answer.id}", params: { format: :json }.merge(options)
    end

    def create_invalid_attr(attributes)
      params = { answer: attributes, format: :json, access_token: access_token.token }
      post "/api/v1/questions/#{question.id}/answers", params: params
    end
  end
end
