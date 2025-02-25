class Company < ApplicationRecord
  validates :name, presence: true
  has_many :domains, dependent: :destroy
  has_many :company_markets, dependent: :destroy
  has_many :markets, through: :company_markets
  has_many :software_applications, through: :domains

  class << self
    def ransackable_attributes(auth_object = nil)
      %w[name] + _ransackers.keys
    end
    def ransackable_associations(auth_object = nil)
      %w[domains]
    end
  end
end
