require "test_helper"

class KeywordTest < ActiveSupport::TestCase
  def setup
    @keyword = build(:keyword)
  end

  test "factory is valid" do
    assert @keyword.valid?
  end

  test "name should be present" do
    @keyword.name = ""
    assert_not @keyword.valid?
    assert_includes @keyword.errors[:name], "can't be blank"
  end

  test "name should be unique" do
    create(:keyword, name: "Unique Keyword")
    duplicate = build(:keyword, name: "Unique Keyword")
    assert_not duplicate.valid?
    assert_includes duplicate.errors[:name], "has already been taken"
  end

  test "should destroy dependent keyword_markets" do
    keyword = create(:keyword)
    create(:keyword_market, keyword: keyword)
    assert_difference("KeywordMarket.count", -1) do
      keyword.destroy
    end
  end

  test "should destroy dependent keyword_web_pages" do
    keyword = create(:keyword)
    web_page = create(:web_page)
    create(:keyword_web_page, keyword: keyword, web_page: web_page)
    assert_difference("KeywordWebPage.count", -1) do
      keyword.destroy
    end
  end
end
