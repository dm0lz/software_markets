class FetchSerpWebPagesService < BaseService
  def call(query)
    serp = FetchSerpService.new.call(query)
    urls = serp["search_results"].map { |ser| ser["url"] }
    web_pages = FetchWebPagesService.new.call(urls)
    web_pages.map { |page| page["content"] }.join(" ")
  end
end
