FactoryBot.define do
  factory :answer do
    body { 'AnswerText' }

    trait :invalid do
      body { nil }
    end

    trait :new do
      body { 'new body' }
    end
  end
end
