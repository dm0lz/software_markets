json.extract! feature_extraction_query, :id, :content, :embedding, :search_field, :created_at, :updated_at
json.url admin_feature_extraction_query_url(feature_extraction_query, format: :json)
