class Domain < ApplicationRecord
  belongs_to :company
  has_many :software_applications, dependent: :destroy
  has_many :web_pages, dependent: :destroy
  has_many :keyword_web_pages, dependent: :destroy
  has_many :keywords, through: :keyword_web_pages
  has_many :web_page_chunks, through: :web_pages

  scope :unknown, -> { where(name: [ "example.com", "www.capterra.fr" ]) }

  class << self
    def ransackable_attributes(auth_object = nil)
      %w[name] + _ransackers.keys
    end
  end

  def web_page_chunks_similar_to(query_embedding, limit = 5)
    web_page_chunks.order(Arel.sql("web_page_chunks.embedding <=> '#{query_embedding}'")).limit(limit)
  end

  def generate_extracted_content
    FeatureExtractionQuery.all.each do |query|
      ExtractDomainFeatureJob.perform_later(self, query)
    end
  end
end
