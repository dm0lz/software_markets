class AddUniqIndexToKeywordMarkets < ActiveRecord::Migration[8.0]
  def change
    add_index :keyword_markets, [ :keyword_id, :market_id ], unique: true
  end
end
