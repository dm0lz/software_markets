require "test_helper"

class KeywordWebPageTest < ActiveSupport::TestCase
  def setup
    @keyword_web_page = keyword_web_pages(:one)
    @keyword = keywords(:one)
    @web_page = web_pages(:one)
  end

  test "should be valid" do
    assert @keyword_web_page.valid?
  end

  test "should require a keyword" do
    invalid_keyword_web_page = keyword_web_pages(:one)
    invalid_keyword_web_page.keyword = nil
    assert_not invalid_keyword_web_page.valid?
    assert_includes invalid_keyword_web_page.errors.full_messages, "Keyword must exist"
  end

  test "should require a web_page" do
    invalid_keyword_web_page = keyword_web_pages(:one)
    invalid_keyword_web_page.web_page = nil
    assert_not invalid_keyword_web_page.valid?
    assert_includes invalid_keyword_web_page.errors.full_messages, "Web page must exist"
  end

  test "keyword_id and web_page_id should be unique together" do
    duplicate_keyword_web_page = keyword_web_pages(:one).dup
    assert_not duplicate_keyword_web_page.valid?
    assert_includes duplicate_keyword_web_page.errors.full_messages, "Keyword has already been added to this web_page"
  end

  test "associated keyword should be accessible" do
    assert_equal @keyword, @keyword_web_page.keyword
  end

  test "associated web_page should be accessible" do
    assert_equal @web_page, @keyword_web_page.web_page
  end

  test "should destroy dependent records" do
    assert_difference("KeywordWebPage.count", -1) do
      @keyword_web_page.destroy
    end
  end

  test "should destroy associated keyword when keyword is deleted" do
    keyword_web_page = keyword_web_pages(:two)
    keyword_web_page.keyword.destroy
    assert_not KeywordWebPage.exists?(keyword_web_page.id)
  end

  test "should destroy associated web_page when web_page is deleted" do
    keyword_web_page = keyword_web_pages(:two)
    keyword_web_page.web_page.destroy
    assert_not KeywordWebPage.exists?(keyword_web_page.id)
  end
end
