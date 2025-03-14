FactoryBot.define do
  factory :feature_extraction_query do
    content { "MyText" }
    embedding nil
    search_field { "MyString" }
  end
end
