require "test_helper"

class WebPageChunkTest < ActiveSupport::TestCase
  def setup
    @web_page_chunk = build(:web_page_chunk)
  end

  test "factory is valid" do
    assert @web_page_chunk.valid?
  end

  test "should require content" do
    @web_page_chunk.content = nil
    assert_not @web_page_chunk.valid?
    assert_includes @web_page_chunk.errors[:content], "can't be blank"
  end

  test "should require a web_page" do
    @web_page_chunk.web_page = nil
    assert_not @web_page_chunk.valid?
    assert_includes @web_page_chunk.errors[:web_page], "must exist"
  end

  test "should generate an embedding after create" do
    web_page_chunk = create(:web_page_chunk, content: "Test content")
    assert_not_nil web_page_chunk.reload.embedding
  end

  test "associated web_page should be accessible" do
    web_page = create(:web_page)
    web_page_chunk = create(:web_page_chunk, web_page: web_page)
    assert_equal web_page, web_page_chunk.web_page
  end
end
