class AddEmbeddingToWebPages < ActiveRecord::Migration[8.0]
  def change
    add_column :web_pages, :embedding, :vector, limit: 3584
  end
end
