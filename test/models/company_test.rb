require "test_helper"

class CompanyTest < ActiveSupport::TestCase
  def setup
    @company = create(:company)
  end

  test "should be valid" do
    assert @company.valid?
  end

  test "name should be present" do
    @company.name = ""
    assert_not @company.valid?
  end

  test "should have many markets" do
    market1 = create(:market)
    market2 = create(:market)
    @company.markets << [ market1, market2 ]
    assert_equal 2, @company.markets.count
    assert_includes @company.markets, market1
    assert_includes @company.markets, market2
  end

  test "should destroy associated market_companies when company is destroyed" do
    market = create(:market)
    @company.markets << market
    assert_difference "CompanyMarket.count", -1 do
      @company.destroy
    end
  end

  test "should not destroy associated markets when company is destroyed" do
    market = create(:market)
    @company.markets << market
    assert_no_difference "Market.count" do
      @company.destroy
    end
  end
end
