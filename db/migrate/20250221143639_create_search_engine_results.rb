class CreateSearchEngineResults < ActiveRecord::Migration[8.0]
  def change
    create_table :search_engine_results do |t|
      t.string :site_name, null: false
      t.string :url, null: false
      t.string :title, null: false
      t.string :query, null: false
      t.text :description, null: false

      t.timestamps
    end
  end
end
