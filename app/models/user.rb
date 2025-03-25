class User < ApplicationRecord
  has_secure_password
  has_secure_token :api_token, length: 36
  has_many :sessions, dependent: :destroy
  has_many :api_sessions, dependent: :destroy
  before_create :add_api_credit

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email_address, presence: true, uniqueness: true, format: { with: VALID_EMAIL_REGEX }
  validates :password_digest, presence: true

  normalizes :email_address, with: ->(e) { e.strip.downcase }

  def is_admin?
    role == "admin"
  end

  private
  def add_api_credit
    self.api_credit = 500
  end
end
