class KeywordMarket < ApplicationRecord
  belongs_to :keyword
  belongs_to :market
  validates :keyword_id, uniqueness: { scope: :market_id, message: "has already been added to this market" }
end
