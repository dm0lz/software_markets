FactoryBot.define do
  factory :provider do
    sequence(:name) { |n| "Provider #{n}" }
    sequence(:domain) { |n| "domain-#{n}.com" }
  end
end
