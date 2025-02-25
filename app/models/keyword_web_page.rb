class KeywordWebPage < ApplicationRecord
  belongs_to :keyword
  belongs_to :web_page
  belongs_to :domain
end
