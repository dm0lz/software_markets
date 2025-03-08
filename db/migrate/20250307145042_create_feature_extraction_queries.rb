class CreateFeatureExtractionQueries < ActiveRecord::Migration[8.0]
  def change
    create_table :feature_extraction_queries do |t|
      t.text :content
      t.vector :embedding, limit: 1024
      t.string :search_field

      t.timestamps
    end
  end
end
