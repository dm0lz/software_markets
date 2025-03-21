require "test_helper"

class DomainEmailsFinderServiceTest < ActiveJob::TestCase
  test "should get emails from domain" do
    emails = SearchEngine::DomainEmailsFinderService.new.call("taboola.com")
    assert emails.count > 0
  end
end
