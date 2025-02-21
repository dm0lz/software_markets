class AddDescriptionToMarketProviders < ActiveRecord::Migration[8.0]
  def change
    add_column :market_providers, :description, :text
  end
end
