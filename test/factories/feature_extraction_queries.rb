FactoryBot.define do
  factory :feature_extraction_query do
    content { "Instruct: Given a query, retrieve relevant chunks that answer the query.\n Query: what is the primary product or service offered by the company ?" }
    embedding { nil }
    sequence(:search_field) { |n| "product_or_service_provided_#{n}" }
  end
end
