FactoryBot.define do
  factory :domain do
    sequence(:name) { |n| "Domain #{n}" }
    association :company, factory: :company
  end
end
