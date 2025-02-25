class WebPage < ApplicationRecord
  validates :url, presence: true
  belongs_to :domain
  has_many :keyword_web_pages, dependent: :destroy
  has_many :keywords, through: :keyword_web_pages

  def extracted_content_json
    JSON.parse(extracted_content.match(/{.*}/m).to_s) rescue nil
  end
end
