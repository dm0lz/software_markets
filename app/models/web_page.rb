class WebPage < ApplicationRecord
  include Embeddable
  embeddable source_column: :summary, target_column: :summary_embedding

  after_save :summarize, :update_web_page_chunks, if: -> { saved_change_to_content? }

  belongs_to :domain
  has_many :keyword_web_pages, dependent: :destroy
  has_many :keywords, through: :keyword_web_pages
  has_many :web_page_chunks, dependent: :destroy

  validates :url, presence: true, uniqueness: true

  scope :summary_similar_to, ->(query_embedding, limit = 5) {
    order(Arel.sql("web_pages.summary_embedding <=> '#{query_embedding}'")).limit(limit)
  }

  def web_page_chunks_similar_to(query_embedding, limit = 5)
    web_page_chunks.order(Arel.sql("web_page_chunks.embedding <=> '#{query_embedding}'")).limit(limit)
  end

  def update_web_page_chunks
    web_page_chunks.destroy_all
    chunks.each do |chunk|
      web_page_chunks.create(content: chunk)
    end
  end

  def summarize
    SummarizeWebPageJob.perform_later(self)
  end

  private
  def chunks(chunk_size = 1024, overlap = 100)
    content.split(/(?<=[.!?])(\s+)|(?<=\G.{512})/).reduce([ "" ]) do |chunks, sentence|
      chunks.last.length + sentence.length < chunk_size ? chunks.tap { |c| c[-1] += sentence } : chunks << (chunks.last[-overlap..] || "") + sentence
    end
  end
end
