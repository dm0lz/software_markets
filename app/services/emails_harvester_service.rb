class EmailsHarvesterService < BaseService
  def call(domain)
    serp = FetchSerpService.new.call("inbody%3A*%40#{domain.name}")
    urls = serp["search_results"].map { |ser| ser["url"] }
    web_pages = FetchWebPagesService.new.call(urls)
    content = web_pages.map { |page| page["content"] }.join(" ")
    content.scan(/\b[A-Za-z0-9._%+-]+@#{Regexp.escape(domain.name)}\b/i).uniq
  end
end
