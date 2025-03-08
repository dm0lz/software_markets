class WebPage < ApplicationRecord
  validates :url, presence: true
  belongs_to :domain
  has_many :keyword_web_pages, dependent: :destroy
  has_many :keywords, through: :keyword_web_pages
  has_many :web_page_chunks, dependent: :destroy

  def extracted_content_json
    JSON.parse(extracted_content.match(/{.*}/m).to_s) rescue nil
  end

  def web_page_chunks_similar_to(query_embedding, limit = 5)
    web_page_chunks.order(Arel.sql("web_page_chunks.embedding <=> '#{query_embedding}'")).limit(limit)
  end

  def create_web_page_chunks
    chunk_size, overlap = 1024, 100
    (0..content.length).step(chunk_size - overlap).map do |i|
      web_page_chunk = web_page_chunks.create(content: content[i, chunk_size])
      GenerateEmbeddingJob.perform_later(web_page_chunk)
    end
  end
end
