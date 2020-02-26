FactoryBot.define do
  factory :comment, class: 'Comment' do
    body { 'MyComment' }

    trait :invalid do
      body { nil }
    end

    trait :new do
      body { 'new body' }
    end

    trait :for_question do
      commentable_type { 'Question' }
    end

    trait :for_answer do
      commentable_type { 'Answer' }
    end
  end
end
