FactoryBot.define do
  factory :market_provider do
    association :market, factory: :market
    association :provider, factory: :provider
    market_name { "MyString" }
    market_url { "MyString" }
  end
end
