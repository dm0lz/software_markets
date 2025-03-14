require "test_helper"

class WebPageTest < ActiveSupport::TestCase
  include ActiveJob::TestHelper

  def setup
    @web_page = create(:web_page)
    @domain = @web_page.domain
  end

  test "should be valid" do
    assert @web_page.valid?
  end

  test "should require a url" do
    @web_page.url = nil
    assert_not @web_page.valid?
    assert_includes @web_page.errors.full_messages, "Url can't be blank"
  end

  test "should require a content" do
    @web_page.content = nil
    assert_not @web_page.valid?
    assert_includes @web_page.errors.full_messages, "Content can't be blank"
  end

  test "should require a domain" do
    @web_page.domain = nil
    assert_not @web_page.valid?
    assert_includes @web_page.errors.full_messages, "Domain must exist"
  end

  test "associated domain should be accessible" do
    assert_equal @domain, @web_page.domain
  end

  test "should destroy dependent keyword_web_pages" do
    keyword = create(:keyword)
    @web_page.keywords << keyword

    assert_difference("KeywordWebPage.count", -1) do
      @web_page.destroy
    end
  end

  test "should destroy dependent web_page_chunks" do
    assert_difference("WebPageChunk.count", -1) do
      @web_page.destroy
    end
  end

  test "web_page_chunks_similar_to should return ordered web page chunks" do
    query = create(:feature_extraction_query)
    query.reload

    similar_chunks = @web_page.web_page_chunks_similar_to(query.embedding, 1)
    assert_equal @web_page.web_page_chunks.first, similar_chunks.first
  end
end
