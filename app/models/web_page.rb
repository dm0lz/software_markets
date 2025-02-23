class WebPage < ApplicationRecord
  validates :url, presence: true
  belongs_to :domain

  def extracted_content_json
    JSON.parse(extracted_content.match(/{.*}/m).to_s) rescue nil
  end
end
