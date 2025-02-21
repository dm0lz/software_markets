class CreateCompanies < ActiveRecord::Migration[8.0]
  def change
    create_table :companies do |t|
      t.string :name, null: false
      t.references :market, null: false, foreign_key: true

      t.timestamps
    end
  end
end
