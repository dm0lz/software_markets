class AddUniqIndexToCompanyMarkets < ActiveRecord::Migration[8.0]
  def change
    add_index :company_markets, [ :company_id, :market_id ], unique: true
  end
end
