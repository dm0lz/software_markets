class SearchEngineResult < ApplicationRecord
  validates :site_name, :url, :title, :description, presence: true
end
