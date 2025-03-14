require "test_helper"

class KeywordMarketTest < ActiveSupport::TestCase
  def setup
    @keyword_market = create(:keyword_market)
    @keyword = @keyword_market.keyword
    @market = @keyword_market.market
  end

  test "should be valid" do
    assert @keyword_market.valid?
  end

  test "should require a keyword" do
    keyword_market = build(:keyword_market, keyword: nil)
    assert_not keyword_market.valid?
    assert_includes keyword_market.errors.full_messages, "Keyword must exist"
  end

  test "should require a market" do
    keyword_market = build(:keyword_market, market: nil)
    assert_not keyword_market.valid?
    assert_includes keyword_market.errors.full_messages, "Market must exist"
  end

  test "keyword_id and market_id should be unique together" do
    duplicate_keyword_market = build(:keyword_market,
      keyword: @keyword_market.keyword,
      market: @keyword_market.market)
    assert_not duplicate_keyword_market.valid?
    assert_includes duplicate_keyword_market.errors.full_messages, "Keyword has already been added to this market"
  end

  test "associated keyword should be accessible" do
    assert_equal @keyword, @keyword_market.keyword
  end

  test "associated market should be accessible" do
    assert_equal @market, @keyword_market.market
  end

  test "should destroy dependent records" do
    assert_difference("KeywordMarket.count", -1) do
      @keyword_market.destroy
    end
  end

  test "should destroy associated keyword when keyword is deleted" do
    keyword_market = create(:keyword_market)
    keyword_market.keyword.destroy
    assert_not KeywordMarket.exists?(keyword_market.id)
  end

  test "should destroy associated market when market is deleted" do
    keyword_market = create(:keyword_market)
    keyword_market.market.destroy
    assert_not KeywordMarket.exists?(keyword_market.id)
  end
end
