require "test_helper"

class DomainTest < ActiveSupport::TestCase
  def setup
    @domain = build(:domain)
  end

  test "factory is valid" do
    assert @domain.valid?
  end

  test "name should be present" do
    @domain.name = ""
    assert_not @domain.valid?
    assert_includes @domain.errors[:name], "can't be blank"
  end

  test "name should be unique" do
    create(:domain, name: "example.com")
    duplicate = build(:domain, name: "example.com")
    assert_not duplicate.valid?
    assert_includes duplicate.errors[:name], "has already been taken"
  end

  test "associated company should be accessible" do
    company = create(:company)
    domain = create(:domain, company: company)
    assert_equal company, domain.company
  end

  test "should destroy associated web pages when domain is destroyed" do
    domain = create(:domain)
    create(:web_page, domain: domain)
    assert_difference("WebPage.count", -1) do
      domain.destroy
    end
  end
   test "should destroy associated keyword_web_pages when domain is destroyed" do
      domain = create(:domain)
      web_page = create(:web_page, domain: domain)
      create(:keyword_web_page, web_page: web_page)
      assert_difference("KeywordWebPage.count", -1) do
        domain.destroy
      end
    end
end
