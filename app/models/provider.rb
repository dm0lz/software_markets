class Provider < ApplicationRecord
  validates :name, :domain, presence: true
  has_many :market_providers, dependent: :destroy
  has_many :markets, through: :market_providers
end
