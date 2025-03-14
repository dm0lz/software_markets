FactoryBot.define do
  factory :market do
    sequence(:name) { |n| "Market #{n}" }
  end
end
