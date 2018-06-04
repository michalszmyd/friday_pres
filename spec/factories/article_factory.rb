FactoryBot.define do
  factory :activity, class: Activity do
    skip_create

    sequence(:id)
    user
    created_at { Time.current }

    trait :comment do
      type 'comment'
      description 'Test Message'
    end

    trait :like do
      type 'like'
      description ''
    end

    trait :reaction do
      type 'reaction'
      description 'smile'
    end

    initialize_with do
      new(
        id: id,
        user_id: user.id,
        created_at: created_at,
        type: type,
        description: description
      )
    end
  end
end
