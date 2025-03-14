require "test_helper"

class RetrieveCompanyDomainJobTest < ActiveJob::TestCase
  def setup
    @company = create(:company, name: "pdfescape")
  end

  test "should get domain from company name" do
    RetrieveCompanyDomainJob.perform_later(@company)
    assert_equal "pdfescape.com", @company.domains.first.name
  end
end
