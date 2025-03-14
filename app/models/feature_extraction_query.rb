class FeatureExtractionQuery < ApplicationRecord
  include Embeddable
  validates :search_field, presence: true, uniqueness: true
end
