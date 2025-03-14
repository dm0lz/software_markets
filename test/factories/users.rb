FactoryBot.define do
  factory :user do
    sequence(:email_address) { |n| "email-#{n}@example.com" }
    password_digest { BCrypt::Password.create("password") }
    factory :admin do
      role { "admin" }
    end
  end
end
