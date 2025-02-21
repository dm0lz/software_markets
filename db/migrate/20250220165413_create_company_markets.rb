class CreateCompanyMarkets < ActiveRecord::Migration[8.0]
  def change
    create_table :company_markets do |t|
      t.references :company, null: false, foreign_key: true
      t.references :market, null: false, foreign_key: true

      t.timestamps
    end
  end
end
