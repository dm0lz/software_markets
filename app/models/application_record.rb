class ApplicationRecord < ActiveRecord::Base
  primary_abstract_class
  # connects_to database: { writing: :secondary, reading: :secondary }
end
