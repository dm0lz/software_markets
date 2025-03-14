require "test_helper"

class SearchEngineResultTest < ActiveSupport::TestCase
  def setup
    @search_engine_result = build(:search_engine_result)
  end

  test "factory is valid" do
    assert @search_engine_result.valid?
  end

  %w[site_name url title query description position].each do |attribute|
    test "should require #{attribute}" do
      @search_engine_result.send("#{attribute}=", nil)
      assert_not @search_engine_result.valid?
      assert_includes @search_engine_result.errors[attribute], "can't be blank"
    end
  end
end
