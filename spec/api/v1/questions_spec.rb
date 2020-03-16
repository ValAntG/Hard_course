require 'rails_helper'

describe 'Question API' do
  let(:user) { create :user }
  let(:access_token) { create(:access_token) }

  describe 'GET /index' do
    context 'when unauthorized' do
      it 'return 401 status if there is no access_token' do
        get '/api/v1/questions', params: { format: :json }
        expect(response.status).to eq 401
      end

      it 'return 401 status if access_token is valid' do
        get '/api/v1/questions', params: { format: :json, access_token: '1234' }
        expect(response.status).to eq 401
      end
    end

    context 'when authorized' do
      let!(:question) { create :question }

      before do
        create :question
        get '/api/v1/questions', params: { format: :json, access_token: access_token.token }
      end

      it { expect(response).to be_success }
      it { expect(response.body).to have_json_size(2) }

      %w[id title body created_at updated_at].each do |attr|
        it { expect(response.body).to be_json_eql(question.send(attr.to_sym).to_json).at_path("0/#{attr}") }
      end
    end
  end

  describe 'GET /show' do
    let!(:question) { create :question }

    context 'when unauthorized' do
      it 'return 401 status if there is no access_token' do
        get "/api/v1/questions/#{question.id}", params: { format: :json }
        expect(response.status).to eq 401
      end

      it 'return 401 status if access_token is valid' do
        get "/api/v1/questions/#{question.id}", params: { format: :json, access_token: '1234' }
        expect(response.status).to eq 401
      end
    end

    context 'when authorized' do
      let!(:comment) { create(:comment, commentable: question, user: user) }

      before { get "/api/v1/questions/#{question.id}", params: { format: :json, access_token: access_token.token } }

      it { expect(response).to be_success }

      %w[id title body created_at updated_at].each do |attr|
        it { expect(response.body).to be_json_eql(question.send(attr.to_sym).to_json).at_path(attr.to_s) }
      end

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

    context 'when authorized invalid path' do
      subject(:parsed_response) { JSON.parse(response.body) }

      before { get "/api/v1/questions/#{question.id + 2}", params: { format: :json, access_token: access_token.token } }

      it { expect(parsed_response['status']).to eq('error') }
      it { expect(parsed_response['code']).to eq(404) }
      it { expect(parsed_response['message']).to eq("Can't find question") }
    end
  end

  describe 'POST #create' do
    subject(:post_create) { post '/api/v1/questions', params: params }

    before { post '/api/v1/questions', params: params }

    context 'when unauthorized return 401 status if there is no access_token' do
      subject(:params) { { format: :json } }

      it { expect(response.status).to eq 401 }
    end

    context 'when unauthorized return 401 status if access_token is valid' do
      subject(:params) { { format: :json, access_token: '1234' } }

      it { expect(response.status).to eq 401 }
    end

    context 'with valid attributes' do
      subject(:params) { { question: attributes_for(:question), format: :json, access_token: access_token.token } }

      it { expect(response).to be_success }
      it { expect { post_create }.to change(Question, :count).by(1) }
      it { expect(Question.last.user_id).to eq(access_token.resource_owner_id) }
      it { expect(Question.last.body).to eq(attributes_for(:question)[:body]) }
      it { expect(Question.last.title).to eq(attributes_for(:question)[:title]) }
    end

    context 'with invalid attributes' do
      subject(:params) do
        { question: attributes_for(:question, :invalid), format: :json, access_token: access_token.token }
      end

      it { expect { post_create }.not_to change(Question, :count) }
      it { expect(response).not_to be_success }
      it { expect(response.status).to eq 422 }
    end

    context 'with invalid title' do
      subject(:params) do
        { question: attributes_for(:question, :invalid_title), format: :json, access_token: access_token.token }
      end

      it { expect { post_create }.not_to change(Question, :count) }
      it { expect(response).not_to be_success }
      it { expect(response.status).to eq 422 }
    end

    context 'with invalid body' do
      subject(:params) do
        { question: attributes_for(:question, :invalid_body), format: :json, access_token: access_token.token }
      end

      it { expect { post_create }.not_to change(Question, :count) }
      it { expect(response).not_to be_success }
      it { expect(response.status).to eq 422 }
    end
  end
end
