class FindDomainEmailsJob < ApplicationJob
  queue_as :default

  def perform(domain_name, session_id)
    emails = DomainEmailsFinderService.new.call(domain_name)
    ActionCable.server.broadcast(
      "domain_emails_finder_#{session_id}",
      { message: emails }
    )
  end
end
