require "test_helper"

class MarketTest < ActiveSupport::TestCase
  def setup
    @market = build(:market)
  end

  test "factory is valid" do
    assert @market.valid?
  end

  test "name should be present" do
    @market.name = ""
    assert_not @market.valid?
    assert_includes @market.errors[:name], "can't be blank"
  end

  test "name should be unique" do
    create(:market, name: "Unique Market")
    duplicate = build(:market, name: "Unique Market")
    assert_not duplicate.valid?
    assert_includes duplicate.errors[:name], "has already been taken"
  end

  test "market can have many companies" do
    market = create(:market)
    company1 = create(:company)
    company2 = create(:company)
    market.companies << [ company1, company2 ]

    assert_includes market.companies, company1
    assert_includes market.companies, company2
  end
end
