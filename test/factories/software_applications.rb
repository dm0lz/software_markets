FactoryBot.define do
  factory :software_application do
    name { "MyString" }
    association :domain, factory: :domain
  end
end
