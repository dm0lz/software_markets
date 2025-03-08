class AddUniqIndexToMarketProviders < ActiveRecord::Migration[8.0]
  def change
    add_index :market_providers, [ :provider_id, :market_id ], unique: true
  end
end
