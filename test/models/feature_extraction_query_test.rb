require "test_helper"

class FeatureExtractionQueryTest < ActiveSupport::TestCase
  def setup
    @feature_extraction_query = build(:feature_extraction_query)
  end

  test "factory is valid" do
    assert @feature_extraction_query.valid?
  end

  test "should require a content" do
    @feature_extraction_query.content = ""
    assert_not @feature_extraction_query.valid?
    assert_includes @feature_extraction_query.errors[:content], "can't be blank"
  end

  test "should require a search_field" do
    @feature_extraction_query.search_field = nil
    assert_not @feature_extraction_query.valid?
    assert_includes @feature_extraction_query.errors[:search_field], "can't be blank"
  end

  test "should generate embedding" do
    @feature_extraction_query.content = "Test content"
    @feature_extraction_query.save
    assert_not_nil @feature_extraction_query.reload.embedding
  end
end
