class AddUrlToSoftwareApplications < ActiveRecord::Migration[8.0]
  def change
    add_column :software_applications, :url, :string
  end
end
