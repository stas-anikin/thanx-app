FactoryBot.define do
  factory :redemption do
    association :user, factory: [ :user, :with_points ]
    reward
    points_spent { nil }
    status { "pending" }

    trait :completed do
      status { "completed" }
    end

    trait :cancelled do
      status { "cancelled" }
    end
  end
end
