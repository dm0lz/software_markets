class SoftwareApplication < ApplicationRecord
  belongs_to :domain
  delegate :company, to: :domain
end
