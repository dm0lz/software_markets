FactoryBot.define do
  factory :api_session do
    user { nil }
    ip_address { "MyString" }
    user_agent { "MyString" }
  end
end
