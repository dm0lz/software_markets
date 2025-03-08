class SearchEngineResult < ApplicationRecord
  validates :site_name, :url, :title, :query, :description, :position, presence: true
end
