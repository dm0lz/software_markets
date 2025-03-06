class CreateWebPageChunks < ActiveRecord::Migration[8.0]
  def change
    create_table :web_page_chunks do |t|
      t.references :web_page, null: false, foreign_key: true
      t.text :content
      t.vector :embedding, limit: 3584

      t.timestamps
    end
  end
end
