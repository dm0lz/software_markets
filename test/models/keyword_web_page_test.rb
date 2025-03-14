require "test_helper"

class KeywordWebPageTest < ActiveSupport::TestCase
  def setup
    @keyword_web_page = create(:keyword_web_page)
    @keyword = @keyword_web_page.keyword
    @web_page = @keyword_web_page.web_page
  end

  test "should be valid" do
    assert @keyword_web_page.valid?
  end

  test "should require a keyword" do
    keyword_web_page = build(:keyword_web_page, keyword: nil)
    assert_not keyword_web_page.valid?
    assert_includes keyword_web_page.errors.full_messages, "Keyword must exist"
  end

  test "should require a web_page" do
    keyword_web_page = build(:keyword_web_page, web_page: nil)
    assert_not keyword_web_page.valid?
    assert_includes keyword_web_page.errors.full_messages, "Web page must exist"
  end

  test "keyword_id and web_page_id should be unique together" do
    original = create(:keyword_web_page)
    duplicate = build(:keyword_web_page, keyword: original.keyword, web_page: original.web_page)
    assert_not duplicate.valid?
    assert_includes duplicate.errors.full_messages, "Keyword has already been added to this web_page"
  end

  test "associated keyword should be accessible" do
    assert_equal @keyword, @keyword_web_page.keyword
  end

  test "associated web_page should be accessible" do
    assert_equal @web_page, @keyword_web_page.web_page
  end

  test "should destroy dependent records" do
    keyword_web_page = create(:keyword_web_page)
    assert_difference("KeywordWebPage.count", -1) do
      keyword_web_page.destroy
    end
  end

  test "should destroy associated keyword when keyword is deleted" do
    keyword_web_page = create(:keyword_web_page)
    keyword_web_page.keyword.destroy
    assert_not KeywordWebPage.exists?(keyword_web_page.id)
  end

  test "should destroy associated web_page when web_page is deleted" do
    keyword_web_page = create(:keyword_web_page)
    keyword_web_page.web_page.destroy
    assert_not KeywordWebPage.exists?(keyword_web_page.id)
  end
end
