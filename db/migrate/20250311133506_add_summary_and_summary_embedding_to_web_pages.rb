class AddSummaryAndSummaryEmbeddingToWebPages < ActiveRecord::Migration[8.0]
  def change
    add_column :web_pages, :summary, :text
    add_column :web_pages, :summary_embedding, :vector, limit: 1024
  end
end
