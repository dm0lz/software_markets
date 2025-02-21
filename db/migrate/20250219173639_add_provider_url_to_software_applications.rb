class AddProviderUrlToSoftwareApplications < ActiveRecord::Migration[8.0]
  def change
    add_column :software_applications, :provider_url, :string
  end
end
