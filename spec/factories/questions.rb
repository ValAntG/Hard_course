FactoryBot.define do
  factory :question do
    user
    title { 'MyString' }
    body  { 'MyText' }

    trait :invalid_body do
      body { nil }
    end

    trait :invalid_title do
      title { nil }
    end

    trait :invalid do
      body { nil }
      title { nil }
    end

    trait :new_body do
      body { 'new body' }
    end

    trait :new_title do
      title { 'new title' }
    end
  end
end
