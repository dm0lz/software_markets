module Public
  class DomainEmailsController < ApplicationController
    def index
    end

    def create
      FindDomainEmailsJob.perform_later(params.require(:domain_name), session_id)
      ActionCable.server.broadcast(
        "domain_emails_finder_#{session_id}",
        { message: "Performing Search..." }
      )
    end
  end
end
