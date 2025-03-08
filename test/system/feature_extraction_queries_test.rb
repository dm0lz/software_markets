require "application_system_test_case"

class FeatureExtractionQueriesTest < ApplicationSystemTestCase
  setup do
    @feature_extraction_query = feature_extraction_queries(:one)
  end

  test "visiting the index" do
    visit feature_extraction_queries_url
    assert_selector "h1", text: "Feature extraction queries"
  end

  test "should create feature extraction query" do
    visit feature_extraction_queries_url
    click_on "New feature extraction query"

    fill_in "Content", with: @feature_extraction_query.content
    fill_in "Embedding", with: @feature_extraction_query.embedding
    fill_in "Search field", with: @feature_extraction_query.search_field
    click_on "Create Feature extraction query"

    assert_text "Feature extraction query was successfully created"
    click_on "Back"
  end

  test "should update Feature extraction query" do
    visit feature_extraction_query_url(@feature_extraction_query)
    click_on "Edit this feature extraction query", match: :first

    fill_in "Content", with: @feature_extraction_query.content
    fill_in "Embedding", with: @feature_extraction_query.embedding
    fill_in "Search field", with: @feature_extraction_query.search_field
    click_on "Update Feature extraction query"

    assert_text "Feature extraction query was successfully updated"
    click_on "Back"
  end

  test "should destroy Feature extraction query" do
    visit feature_extraction_query_url(@feature_extraction_query)
    click_on "Destroy this feature extraction query", match: :first

    assert_text "Feature extraction query was successfully destroyed"
  end
end
