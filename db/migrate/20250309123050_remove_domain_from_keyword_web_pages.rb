class RemoveDomainFromKeywordWebPages < ActiveRecord::Migration[8.0]
  def change
    remove_reference :keyword_web_pages, :domain, null: false, foreign_key: true
  end
end
