class AddExtractedContentToWebPages < ActiveRecord::Migration[8.0]
  def change
    add_column :web_pages, :extracted_content, :text
  end
end
