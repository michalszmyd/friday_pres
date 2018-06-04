FactoryBot.define do
  factory :user, class: User do
    sequence(:id) { |n| n*1000*n }
    sequence(:email) { |n| "example.email#{n}@example.com" }
    password 'password'
    created_at { Time.current }
  end
end
