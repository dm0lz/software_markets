class AddRatingCountToSoftwareApplications < ActiveRecord::Migration[8.0]
  def change
    add_column :software_applications, :rating_count, :integer
  end
end
