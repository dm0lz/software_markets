class CreateKeywordMarkets < ActiveRecord::Migration[8.0]
  def change
    create_table :keyword_markets do |t|
      t.references :keyword, null: false, foreign_key: true
      t.references :market, null: false, foreign_key: true

      t.timestamps
    end
  end
end
