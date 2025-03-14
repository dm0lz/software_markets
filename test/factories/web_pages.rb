FactoryBot.define do
  factory :web_page do
    url { "https://example.com" }
    content { "MyString" }
    association :domain, factory: :domain
  end
end
