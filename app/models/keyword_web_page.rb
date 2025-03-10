class KeywordWebPage < ApplicationRecord
  belongs_to :keyword
  belongs_to :web_page
  validates :keyword_id, uniqueness: { scope: :web_page_id, message: "has already been added to this web_page" }
end
