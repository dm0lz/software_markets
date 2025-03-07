class ChangeWebPageChunksEmbeddingDimension < ActiveRecord::Migration[8.0]
  def change
    remove_column :web_page_chunks, :embedding, :vector, limit: 3584
    add_column :web_page_chunks, :embedding, :vector, limit: 1024
  end
end
