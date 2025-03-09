require "test_helper"

class KeywordMarketTest < ActiveSupport::TestCase
  def setup
    @keyword_market = keyword_markets(:one)
    @keyword = keywords(:one)
    @market = markets(:one)
  end

  test "should be valid" do
    assert @keyword_market.valid?
  end

  test "should require a keyword" do
    invalid_keyword_market = keyword_markets(:one)
    invalid_keyword_market.keyword = nil
    assert_not invalid_keyword_market.valid?
    assert_includes invalid_keyword_market.errors.full_messages, "Keyword must exist"
  end

  test "should require a market" do
    invalid_keyword_market = keyword_markets(:one)
    invalid_keyword_market.market = nil
    assert_not invalid_keyword_market.valid?
    assert_includes invalid_keyword_market.errors.full_messages, "Market must exist"
  end

  test "keyword_id and market_id should be unique together" do
    duplicate_keyword_market = keyword_markets(:one).dup
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
    keyword_market = keyword_markets(:two)
    keyword_market.keyword.destroy
    assert_not KeywordMarket.exists?(keyword_market.id)
  end

  test "should destroy associated market when market is deleted" do
    keyword_market = keyword_markets(:two)
    keyword_market.market.destroy
    assert_not KeywordMarket.exists?(keyword_market.id)
  end
end
