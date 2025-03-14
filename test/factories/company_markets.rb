FactoryBot.define do
  factory :company_market do
   association :company, factory: :company
   association :market, factory: :market
  end
end
