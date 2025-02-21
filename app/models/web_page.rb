class WebPage < ApplicationRecord
  validates :url, presence: true
  belongs_to :domain
end
