FactoryBot.define do
  factory :feature_extraction_query do
    content { "Sample content" }
    embedding { nil }
    sequence(:search_field) { |n| "Sample search field #{n}" }
  end
end
