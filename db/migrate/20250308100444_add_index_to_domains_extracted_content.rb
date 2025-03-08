class AddIndexToDomainsExtractedContent < ActiveRecord::Migration[8.0]
  def change
    add_index :domains, :extracted_content, using: :gin
  end
end
