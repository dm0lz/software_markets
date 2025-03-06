class WebPageChunk < ApplicationRecord
  belongs_to :web_page

  scope :including_content, ->(query_embedding, limit = 5) {
    order(Arel.sql("web_pages_chunks.embedding <=> '#{query_embedding}'")).limit(limit)
  }

  def generate_embedding
    GenerateEmbeddingJob.perform_later(self)
  end
end
