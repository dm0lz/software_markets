FactoryBot.define do
  factory :search_engine_result do
    site_name { "Example Site" }
    url { "https://example.com/page" }
    title { "Example Page Title" }
    query { "search query" }
    description { "This is an example search result description" }
    position { 1 }
  end
end
