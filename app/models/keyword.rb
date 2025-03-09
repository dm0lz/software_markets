class Keyword < ApplicationRecord
  validates :name, presence: true, uniqueness: true
  has_many :keyword_markets, dependent: :destroy
  has_many :markets, through: :keyword_markets
  has_many :keyword_web_pages, dependent: :destroy
  has_many :web_pages, through: :keyword_web_pages
  has_many :domains, through: :keyword_web_pages
end
