require 'rails_helper'

RSpec.describe User do
  it { should have_many :questions }
  it { should have_many :answers }
  it { should validate_presence_of :email }
  it { should validate_presence_of :password }

  describe '.find_for_oauth' do
    let!(:user) { create(:user) }
    let(:auth) { OmniAuth::AuthHash.new(provider: 'facebook', uid: '123456') }
    let(:user_find_for_oauth) { described_class.find_for_oauth(auth) }
    let(:authorization) { user_find_for_oauth.authorizations.first }

    context 'when user already has authorization' do
      before { user.authorizations.create(provider: 'facebook', uid: '123456') }

      it 'returns the user' do
        expect(described_class.find_for_oauth(auth)).to eq(user)
      end
    end

    context 'when user has not authorization, and user already exists' do
      let(:auth) { OmniAuth::AuthHash.new(provider: 'facebook', uid: '123456', info: { email: user.email }) }

      it 'does not create new user' do
        expect { user_find_for_oauth }.not_to change(described_class, :count)
      end

      it 'creates authorization for user' do
        expect { user_find_for_oauth }.to change(user.authorizations, :count).by(1)
      end

      it 'creates authorization with provider' do
        expect(authorization.provider).to eq(auth.provider)
      end

      it 'creates authorization with uid' do
        expect(authorization.uid).to eq(auth.uid)
      end

      it 'return the user' do
        expect(user_find_for_oauth).to eq(user)
      end
    end

    context 'when user has not authorization, and user does not exist' do
      let(:auth) { OmniAuth::AuthHash.new(provider: 'facebook', uid: '123456', info: { email: 'new@email.com' }) }

      it 'creates new user' do
        expect { user_find_for_oauth }.to change(described_class, :count).by(1)
      end

      it 'returns new user' do
        expect(user_find_for_oauth).to be_a(described_class)
      end

      it 'fills user email' do
        expect(user_find_for_oauth.email).to eq(auth.info.email)
      end

      it 'creates authorization for user' do
        expect(user_find_for_oauth.authorizations).not_to be_empty
      end

      it 'create authorization with provider' do
        expect(authorization.provider).to eq(auth.provider)
      end

      it 'create authorization with uid' do
        expect(authorization.uid).to eq(auth.uid)
      end
    end
  end
end
