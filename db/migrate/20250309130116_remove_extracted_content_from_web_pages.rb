class RemoveExtractedContentFromWebPages < ActiveRecord::Migration[8.0]
  def change
    remove_column :web_pages, :extracted_content, :text
  end
end
