class EmailsHarvesterService < BaseService
  def call(domain)
    serp_web_pages = FetchSerpWebPagesService.new.call("inbody%3A*%40#{domain.name}")
    serp_web_pages.scan(/\b[A-Za-z0-9._%+-]+@#{Regexp.escape(domain.name)}\b/i).uniq rescue nil
  end
end
