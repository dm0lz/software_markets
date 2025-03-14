FactoryBot.define do
  factory :keyword_web_page do
    association :keyword, factory: :keyword
    association :web_page, factory: :web_page
  end
end
