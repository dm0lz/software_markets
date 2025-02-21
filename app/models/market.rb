class Market < ApplicationRecord
  validates :name, presence: true
  has_many :market_providers
  has_many :providers, through: :market_providers
  has_many :company_markets, dependent: :destroy
  has_many :companies, through: :company_markets

  class << self
    def ransackable_attributes(auth_object = nil)
      %w[name] + _ransackers.keys
    end
  end
end
