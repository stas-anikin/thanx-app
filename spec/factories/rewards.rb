FactoryBot.define do
  factory :reward do
    name { "MyString" }
    description { "MyText" }
    points_cost { 1 }
    is_active { false }
  end
end
