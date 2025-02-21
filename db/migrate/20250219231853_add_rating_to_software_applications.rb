class AddRatingToSoftwareApplications < ActiveRecord::Migration[8.0]
  def change
    add_column :software_applications, :rating, :float
  end
end
