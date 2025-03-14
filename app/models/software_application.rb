class SoftwareApplication < ApplicationRecord
  belongs_to :domain
  delegate :company, to: :domain
  validates :name, presence: true
end
