class CompanyMarket < ApplicationRecord
  belongs_to :company
  belongs_to :market
  validates :company_id, uniqueness: { scope: :market_id, message: "has already been added to this market" }
end
