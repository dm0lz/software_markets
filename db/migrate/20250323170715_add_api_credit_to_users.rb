class AddApiCreditToUsers < ActiveRecord::Migration[8.0]
  def change
    add_column :users, :api_credit, :integer, default: 0
  end
end
