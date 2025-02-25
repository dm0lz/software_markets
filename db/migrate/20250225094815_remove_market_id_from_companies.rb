class RemoveMarketIdFromCompanies < ActiveRecord::Migration[8.0]
  def change
    remove_reference :companies, :market, null: false, foreign_key: true
  end
end
