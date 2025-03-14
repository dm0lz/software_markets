require "test_helper"

class CompanyMarketTest < ActiveSupport::TestCase
  def setup
    @company_market = create(:company_market)
    @company = @company_market.company
    @market = @company_market.market
  end

  test "should be valid" do
    assert @company_market.valid?
  end

  test "should require a company" do
    invalid_company_market = build(:company_market, company: nil)
    assert_not invalid_company_market.valid?
    assert_includes invalid_company_market.errors.full_messages, "Company must exist"
  end

  test "should require a market" do
    invalid_company_market = build(:company_market, market: nil)
    assert_not invalid_company_market.valid?
    assert_includes invalid_company_market.errors.full_messages, "Market must exist"
  end

  test "company_id and market_id should be unique together" do
    duplicate_company_market = @company_market.dup
    assert_not duplicate_company_market.valid?
    assert_includes duplicate_company_market.errors.full_messages, "Company has already been added to this market"
  end

  test "associated company should be accessible" do
    assert_equal @company, @company_market.company
  end

  test "associated market should be accessible" do
    assert_equal @market, @company_market.market
  end

  test "should destroy dependent records" do
    assert_difference("CompanyMarket.count", -1) do
      @company_market.destroy
    end
  end

  test "should destroy associated company when company is deleted" do
    @company.destroy
    assert_not CompanyMarket.exists?(@company_market.id)
  end

  test "should destroy associated market when market is deleted" do
    @market.destroy
    assert_not CompanyMarket.exists?(@company_market.id)
  end
end
