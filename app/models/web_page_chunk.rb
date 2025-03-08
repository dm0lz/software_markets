class WebPageChunk < ApplicationRecord
  include Embeddable
  belongs_to :web_page

  scope :including_content, ->(query_embedding, limit = 5) {
    order(Arel.sql("web_pages_chunks.embedding <=> '#{query_embedding}'")).limit(limit)
  }
end
