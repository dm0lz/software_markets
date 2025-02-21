class CreateSoftwareApplications < ActiveRecord::Migration[8.0]
  def change
    create_table :software_applications do |t|
      t.string :name, null: false
      t.references :domain, null: false, foreign_key: true

      t.timestamps
    end
  end
end
