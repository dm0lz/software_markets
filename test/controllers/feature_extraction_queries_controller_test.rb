require "test_helper"

class FeatureExtractionQueriesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @feature_extraction_query = feature_extraction_queries(:one)
    admin_session = sessions(:admin_session)
    sign_in(admin_session.user)
  end

  def sign_in(user)
    post session_url, params: { email_address: user.email_address, password: "password" }
  end

  test "should get index" do
    get admin_feature_extraction_queries_url
    assert_response :success
  end

  test "should get new" do
    get new_admin_feature_extraction_query_url
    assert_response :success
  end

  test "should create feature_extraction_query" do
    assert_difference("FeatureExtractionQuery.count") do
      post admin_feature_extraction_queries_url, params: { feature_extraction_query: { content: @feature_extraction_query.content, embedding: @feature_extraction_query.embedding, search_field: @feature_extraction_query.search_field } }
    end

    assert_redirected_to admin_feature_extraction_query_url(FeatureExtractionQuery.last)
  end

  test "should show feature_extraction_query" do
    get admin_feature_extraction_query_url(@feature_extraction_query)
    assert_response :success
  end

  test "should get edit" do
    get edit_admin_feature_extraction_query_url(@feature_extraction_query)
    assert_response :success
  end

  test "should update feature_extraction_query" do
    patch admin_feature_extraction_query_url(@feature_extraction_query), params: { feature_extraction_query: { content: @feature_extraction_query.content, embedding: @feature_extraction_query.embedding, search_field: @feature_extraction_query.search_field } }
    assert_redirected_to admin_feature_extraction_query_url(@feature_extraction_query)
  end

  test "should destroy feature_extraction_query" do
    assert_difference("FeatureExtractionQuery.count", -1) do
      delete admin_feature_extraction_query_url(@feature_extraction_query)
    end

    assert_redirected_to admin_feature_extraction_queries_url
  end
end
