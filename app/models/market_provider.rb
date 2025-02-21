class MarketProvider < ApplicationRecord
  validates :market_name, presence: true
  belongs_to :market
  belongs_to :provider
end
