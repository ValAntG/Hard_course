FactoryBot.define do
  factory :authorization do
    user { nil }
    provider { 'MyProvider' }
    uid { 'ProviderUid' }
  end
end
