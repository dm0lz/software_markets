FactoryBot.define do
  factory :session do
    association :user, factory: :user
  end
end
