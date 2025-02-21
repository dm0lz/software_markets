class AddDescriptionToSoftwareApplications < ActiveRecord::Migration[8.0]
  def change
    add_column :software_applications, :description, :text
  end
end
