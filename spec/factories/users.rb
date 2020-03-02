FactoryBot.define do
  sequence :email do |n|
    "user#{n}@test.com"
  end

  factory :user do
    email
    password { '12345678' }
    password_confirmation { '12345678' }
  end

  factory :facebook, class: 'User' do
    provider { 'facebook' }
    uid { '123456' }
  end

  factory :mail, class: 'User' do
    email { 'new@email.com' }
  end
end
