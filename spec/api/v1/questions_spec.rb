require 'rails_helper'

describe 'Question API' do
  let(:user) { create :user }
  let(:access_token) { create(:access_token) }

  describe 'GET /index' do
    let!(:question) { create :question }

    it_behaves_like 'API Authenticable'

    it_behaves_like 'API index when authorized', %w[id title body created_at updated_at] do
      let(:object) { question }
      let(:size) { 2 }
      let(:path) { '0/' }
    end

    def do_request(options = {})
      get '/api/v1/questions', params: { format: :json }.merge(options)
    end

    def index_authorized
      create :question
      get '/api/v1/questions', params: { format: :json, access_token: access_token.token }
    end
  end

  describe 'GET /show' do
    let!(:question) { create :question }

    it_behaves_like 'API Authenticable'
    it_behaves_like 'API show invalid path'

    it_behaves_like 'API index when authorized', %w[id body created_at updated_at] do
      let(:object) { question }
      let(:size) { 8 }
      let(:path) { '' }
    end

    context 'when authorized' do
      let!(:comment) { create(:comment, commentable: question, user: user) }

      before { get "/api/v1/questions/#{question.id}", params: { format: :json, access_token: access_token.token } }

      context 'with comment' do
        it { expect(response.body).to have_json_size(1).at_path('comments') }

        %w[id body created_at updated_at].each do |attr|
          it { expect(response.body).to be_json_eql(comment.send(attr.to_sym).to_json).at_path("comments/0/#{attr}") }
        end
      end

      context 'with attachment' do
        it { expect(response.body).to have_json_size(0).at_path('attachments') }
      end
    end

    def do_request(options = {})
      get "/api/v1/questions/#{question.id}", params: { format: :json }.merge(options)
    end

    def invalid_path
      get "/api/v1/questions/#{question.id + 2}", params: { format: :json, access_token: access_token.token }
    end

    def index_authorized
      get "/api/v1/questions/#{question.id}", params: { format: :json, access_token: access_token.token }
    end
  end

  describe 'POST #create' do
    let(:object) { Question }

    it_behaves_like 'API Authenticable'

    %w[invalid invalid_title invalid_body].each do |attr|
      context "API create #{attr}" do
        it_behaves_like 'API create invalid attributes' do
          let(:attributes) { attributes_for(:question, attr) }
        end
      end
    end

    context 'with valid attributes' do
      subject(:post_create) { post '/api/v1/questions', params: params }

      let(:params) { { question: attributes_for(:question), format: :json, access_token: access_token.token } }

      before { post '/api/v1/questions', params: params }

      it { expect(response).to be_successful }
      it { expect { post_create }.to change(Question, :count).by(1) }
      it { expect(Question.last.user_id).to eq(access_token.resource_owner_id) }
      it { expect(Question.last.body).to eq(attributes_for(:question)[:body]) }
      it { expect(Question.last.title).to eq(attributes_for(:question)[:title]) }
    end

    def do_request(options = {})
      post '/api/v1/questions', params: { format: :json }.merge(options)
    end

    def create_invalid_attr(attributes)
      post '/api/v1/questions', params: { question: attributes, format: :json, access_token: access_token.token }
    end
  end
end
