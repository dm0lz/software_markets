class SerpFetcher::DomainEmailsFinderService < BaseService
  def call(domain_name)
    serp_web_pages = SerpFetcher::WebPagesService.new(search_engine: "duckduckgo", pages_number: 10).call("inbody%3A*%40#{domain_name}")
    serp_web_pages.scan(/\b[A-Za-z0-9._%+-]+@#{Regexp.escape(domain_name)}\b/i).uniq rescue nil
  end
end
