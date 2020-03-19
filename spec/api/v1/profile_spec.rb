require 'rails_helper'

describe 'Profile API' do
  describe 'GET /me' do
    let(:me) { create(:user) }
    let(:access_token) { create(:access_token, resource_owner_id: me.id) }

    it_behaves_like 'API Authenticable'

    it_behaves_like 'API index when authorized', %w[id email created_at updated_at admin] do
      let(:object) { me }
      let(:size) { 6 }
      let(:path) { '' }
    end

    context 'when authorized' do
      before { get '/api/v1/profiles/me', params: { format: :json, access_token: access_token.token } }

      %w[password encrypted_password].each do |attr|
        it { expect(response.body).not_to have_json_path(attr) }
      end
    end

    def do_request(options = {})
      get '/api/v1/profiles/me', params: { format: :json }.merge(options)
    end

    def index_authorized
      get '/api/v1/profiles/me', params: { format: :json, access_token: access_token.token }
    end
  end
end
