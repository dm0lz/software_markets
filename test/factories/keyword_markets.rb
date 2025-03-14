FactoryBot.define do
  factory :keyword_market do
    association :keyword, factory: :keyword
    association :market, factory: :market
  end
end
