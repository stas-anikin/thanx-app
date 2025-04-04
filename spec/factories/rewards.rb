FactoryBot.define do
  factory :reward do
    sequence(:name) { |n| "Reward #{n}" }
    description { "A fantastic reward" }
    points_cost { 100 }
    is_active { true }

    trait :inactive do
      is_active { false }
    end

    trait :expensive do
      points_cost { 5000 }
    end
  end
end
