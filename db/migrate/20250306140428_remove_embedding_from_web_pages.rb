class RemoveEmbeddingFromWebPages < ActiveRecord::Migration[8.0]
  def change
    remove_column :web_pages, :embedding, :vector, limit: 3584
  end
end
