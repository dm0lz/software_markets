require "test_helper"

class MarketProviderTest < ActiveSupport::TestCase
  fixtures :markets, :providers, :market_providers

  def setup
    @market_provider = market_providers(:one)
    @market = markets(:one)
    @provider = providers(:one)
  end

  test "should be valid" do
    assert @market_provider.valid?
  end

  test "should require a market" do
    invalid_market_provider = market_providers(:one)
    invalid_market_provider.market = nil
    assert_not invalid_market_provider.valid?
    assert_includes invalid_market_provider.errors.full_messages, "Market must exist"
  end

  test "should require a provider" do
    invalid_market_provider = market_providers(:one)
    invalid_market_provider.provider = nil
    assert_not invalid_market_provider.valid?
    assert_includes invalid_market_provider.errors.full_messages, "Provider must exist"
  end

  test "market_id and provider_id should be unique together" do
    duplicate_market_provider = @market_provider.dup
    assert_not duplicate_market_provider.valid?
    assert_includes duplicate_market_provider.errors.full_messages, "Market has already been added to this provider"
  end

  test "associated market should be accessible" do
    assert_equal @market, @market_provider.market
  end

  test "associated provider should be accessible" do
    assert_equal @provider, @market_provider.provider
  end

  test "should destroy dependent records" do
    assert_difference("MarketProvider.count", -1) do
      @market_provider.destroy
    end
  end

  test "should destroy associated market when market is deleted" do
    market_provider = market_providers(:two)
    market_provider.market.destroy
    assert_not MarketProvider.exists?(market_provider.id)
  end

  test "should destroy associated provider when provider is deleted" do
    market_provider = market_providers(:two)
    market_provider.provider.destroy
    assert_not MarketProvider.exists?(market_provider.id)
  end

  test "should not be valid without market_name" do
    invalid_market_provider = market_providers(:one)
    invalid_market_provider.market_name = nil
    assert_not invalid_market_provider.valid?
    assert_includes invalid_market_provider.errors.full_messages, "Market name can't be blank"
  end
end
