FactoryBot.define do
  factory :access_token, class: 'Doorkeeper::AccessToken' do
    association :application, factory: :oauth_application, strategy: :build
    resource_owner_id { create(:user).id }
  end
end
