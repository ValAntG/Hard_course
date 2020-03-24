require 'rails_helper'

RSpec.describe User do
  it { should have_many :questions }
  it { should have_many :answers }
  it { should validate_presence_of :email }
  it { should validate_presence_of :password }

  describe '.find_for_oauth' do
    subject(:user_find_for_oauth) { described_class.find_for_oauth(auth) }

    let(:user) { create(:user) }
    let(:authorization) { user_find_for_oauth.authorizations.first }

    context 'when user already has authorization' do
      let(:auth) { OmniAuth::AuthHash.new(attributes_for(:facebook)) }

      before { user.authorizations.create(attributes_for(:facebook)) }

      it 'returns the user' do
        expect(described_class.find_for_oauth(auth)).to eq(user)
      end
    end

    context 'when user has not authorization, and user already exists' do
      let(:auth) { OmniAuth::AuthHash.new({ info: { email: user.email } }.merge(attributes_for(:facebook))) }

      before { user }

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
      let(:auth) { OmniAuth::AuthHash.new({ info: attributes_for(:mail) }.merge(attributes_for(:facebook))) }

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

  describe '.send_daily_digest' do
    let(:users) { create_list(:user, 2) }

    it 'send daily digest to all users' do
      users.each { |user| expect(DailyMailer).to receive(:digest).with(user).and_call_original }
      described_class.send_daily_digest
    end
  end
end
