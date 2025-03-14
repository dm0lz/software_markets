require "test_helper"

class FindDomainEmailsServiceTest < ActiveJob::TestCase
  test "should get emails from domain" do
    emails = FindDomainEmailsService.new.call("taboola.com")
    assert emails.count > 0
  end
end
