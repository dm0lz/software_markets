class CreateProviders < ActiveRecord::Migration[8.0]
  def change
    create_table :providers do |t|
      t.string :name, null: false
      t.string :domain, null: false

      t.timestamps
    end
  end
end
