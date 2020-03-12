require 'rails_helper'

describe 'Profile API' do
  describe 'GET /me' do
    context 'when unauthorized' do
      it 'return 401 status if there is no access_token' do
        get '/api/v1/profiles/me', params: { format: :json }
        expect(response.status).to eq 401
      end

      it 'return 401 status if access_token is valid' do
        get '/api/v1/profiles/me', params: { format: :json, access_token: '1234' }
        expect(response.status).to eq 401
      end
    end

    context 'when authorized' do
      let(:me) { create(:user) }
      let(:access_token) { create(:access_token, resource_owner_id: me.id) }

      before { get '/api/v1/profiles/me', params: { format: :json, access_token: access_token.token } }

      it { expect(response).to be_success }

      %w[id email created_at updated_at admin].each do |attr|
        it { expect(response.body).to be_json_eql(me.send(attr.to_sym).to_json).at_path(attr) }
      end

      %w[password encrypted_password].each do |attr|
        it { expect(response.body).not_to have_json_path(attr) }
      end
    end
  end
end
