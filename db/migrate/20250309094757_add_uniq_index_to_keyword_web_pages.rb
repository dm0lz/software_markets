class AddUniqIndexToKeywordWebPages < ActiveRecord::Migration[8.0]
  def change
    add_index :keyword_web_pages, [ :keyword_id, :web_page_id ], unique: true
  end
end
