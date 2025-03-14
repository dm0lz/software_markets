require "test_helper"

class SoftwareApplicationTest < ActiveSupport::TestCase
  def setup
    @software_application = build(:software_application)
  end

  test "factory is valid" do
    assert @software_application.valid?
  end

  test "should require a name" do
    @software_application.name = ""
    assert_not @software_application.valid?
    assert_includes @software_application.errors[:name], "can't be blank"
  end

  test "should allow description to be nil" do
    @software_application.description = nil
    assert @software_application.valid?
  end

  test "should allow provider_redirect_url to be nil" do
    @software_application.provider_redirect_url = nil
    assert @software_application.valid?
  end

  test "should allow rating to be nil" do
      @software_application.rating = nil
      assert @software_application.valid?
  end

  test "should allow rating_count to be nil" do
      @software_application.rating_count = nil
      assert @software_application.valid?
  end
end
