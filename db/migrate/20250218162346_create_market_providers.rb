class CreateMarketProviders < ActiveRecord::Migration[8.0]
  def change
    create_table :market_providers do |t|
      t.references :market, null: false, foreign_key: true
      t.references :provider, null: false, foreign_key: true
      t.string :market_name, null: false
      t.string :market_url, null: false

      t.timestamps
    end
  end
end
