FactoryBot.define do
  factory :redemption do
    user { nil }
    reward { nil }
    points_spent { 1 }
    status { "MyString" }
  end
end
