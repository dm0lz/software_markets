require "test_helper"

class ProviderTest < ActiveSupport::TestCase
  def setup
    @provider = build(:provider)
  end

  test "factory is valid" do
    assert @provider.valid?
  end

  test "name should be present" do
    @provider.name = ""
    assert_not @provider.valid?
    assert_includes @provider.errors[:name], "can't be blank"
  end

  test "domain should be present" do
    @provider.domain = ""
    assert_not @provider.valid?
    assert_includes @provider.errors[:domain], "can't be blank"
  end

  test "name should be unique" do
    create(:provider, name: "UniqueName")
    duplicate = build(:provider, name: "UniqueName")
    assert_not duplicate.valid?
    assert_includes duplicate.errors[:name], "has already been taken"
  end

  test "domain should be unique" do
    create(:provider, domain: "example.com")
    duplicate = build(:provider, domain: "example.com")
    assert_not duplicate.valid?
    assert_includes duplicate.errors[:domain], "has already been taken"
  end
end
