require "test_helper"

class ScrapDomainJobTest < ActiveJob::TestCase
  def setup
    @domain = create(:domain, name: "skuuudle.com")
  end

  test "should scrap domain" do
    ScrapDomainJob.perform_later(@domain)
    assert @domain.web_pages.count > 0
  end
end
