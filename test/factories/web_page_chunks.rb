FactoryBot.define do
  factory :web_page_chunk do
    content { "MyString" }
    embedding { nil }
    association :web_page, factory: :web_page
  end
end
