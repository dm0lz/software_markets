class DomainEmailsFinderService < BaseService
  def call(domain_name)
    serp_web_pages = FetchSerpWebPagesService.new.call("inbody%3A*%40#{domain_name}")
    serp_web_pages.scan(/\b[A-Za-z0-9._%+-]+@#{Regexp.escape(domain_name)}\b/i).uniq rescue nil
  end
end
