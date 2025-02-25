class CreateKeywordWebPages < ActiveRecord::Migration[8.0]
  def change
    create_table :keyword_web_pages do |t|
      t.references :keyword, null: false, foreign_key: true
      t.references :web_page, null: false, foreign_key: true
      t.references :domain, null: false, foreign_key: true

      t.timestamps
    end
  end
end
