class AddContentToWebPages < ActiveRecord::Migration[8.0]
  def change
    add_column :web_pages, :content, :text
  end
end
