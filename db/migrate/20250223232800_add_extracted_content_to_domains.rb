class AddExtractedContentToDomains < ActiveRecord::Migration[8.0]
  def change
    add_column :domains, :extracted_content, :jsonb, default: {}, null: false
  end
end
