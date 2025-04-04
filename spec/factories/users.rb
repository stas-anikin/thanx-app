FactoryBot.define do
  factory :user do
    sequence(:email) { |n| "user#{n}@example.com" }
    points_balance { 0 }

    trait :with_points do
      points_balance { 1000 }
    end
  end
end
