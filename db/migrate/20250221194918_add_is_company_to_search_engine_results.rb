class AddIsCompanyToSearchEngineResults < ActiveRecord::Migration[8.0]
  def change
    add_column :search_engine_results, :is_company, :boolean
  end
end
