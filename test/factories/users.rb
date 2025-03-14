FactoryBot.define do
  factory :user do
    email_address { "MyString" }
    password_digest { BCrypt::Password.create("password") }
    role { "admin" }
  end
end
