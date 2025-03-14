FactoryBot.define do
  factory :web_page do
    sequence(:url) { |n| "https://example-#{n}.com" }
    content { "MyString" }
    association :domain, factory: :domain
  end
end
