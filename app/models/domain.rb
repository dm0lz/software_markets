class Domain < ApplicationRecord
  validates :name, presence: true
  belongs_to :company
  has_many :software_applications, dependent: :destroy
  has_many :web_pages, depedent: :destroy
  has_many :keyword_web_pages, dependent: :destroy
  has_many :keywords, through: :keyword_web_pages

  class << self
    def ransackable_attributes(auth_object = nil)
      %w[name] + _ransackers.keys
    end
  end
end
