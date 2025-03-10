class WebPage < ApplicationRecord
  validates :url, :content, presence: true
  belongs_to :domain
  has_many :keyword_web_pages, dependent: :destroy
  has_many :keywords, through: :keyword_web_pages
  has_many :web_page_chunks, dependent: :destroy

  def web_page_chunks_similar_to(query_embedding, limit = 5)
    web_page_chunks.order(Arel.sql("web_page_chunks.embedding <=> '#{query_embedding}'")).limit(limit)
  end

  def create_web_page_chunks(chunk_size = 1024, overlap = 100)
    (0..content.length).step(chunk_size - overlap).map do |i|
      web_page_chunks.create(content: content[i, chunk_size])
    end
  end

  # def chunks(chunk_size = 1024, overlap = 100)
  #   content.split(/(?<=[.!?])\s+/).reduce([ "" ]) do |chunks, sentence|
  #     chunks.last.length + sentence.length < chunk_size ? chunks.tap { |c| c[-1] += sentence } : chunks << (chunks.last[-overlap..] || "") + sentence
  #   end
  # end
end
