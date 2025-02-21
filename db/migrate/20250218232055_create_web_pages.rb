class CreateWebPages < ActiveRecord::Migration[8.0]
  def change
    create_table :web_pages do |t|
      t.string :url, null: false
      t.references :domain, null: false, foreign_key: true

      t.timestamps
    end
  end
end
