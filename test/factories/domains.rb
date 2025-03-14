FactoryBot.define do
  factory :domain do
    name { "MyString" }
    association :company, factory: :company
  end
end
