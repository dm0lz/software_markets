FactoryBot.define do
  factory :software_application do
    sequence(:name) { |n| "Software Application #{n}" }
    association :domain, factory: :domain
    provider_url { "https://example.com/provider_page" }
    url { "https://example.com/software_page" }
    description { "A great software application" }
    provider_redirect_url { "https://example.com/redirect" }
    rating { 4.5 }
    rating_count { 100 }
  end
end
