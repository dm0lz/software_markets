class MarketProvider < ApplicationRecord
  belongs_to :market
  belongs_to :provider
  validates :market_name, presence: true
  validates :market_id, uniqueness: { scope: :provider_id, message: "has already been added to this provider" }
end
