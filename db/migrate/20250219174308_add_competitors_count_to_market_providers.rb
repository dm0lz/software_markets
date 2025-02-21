class AddCompetitorsCountToMarketProviders < ActiveRecord::Migration[8.0]
  def change
    add_column :market_providers, :competitors_count, :integer
  end
end
