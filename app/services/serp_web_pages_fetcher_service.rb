class SerpWebPagesFetcherService < BaseService
  def call(query)
    serp = DuckduckgoSerpFetcherService.new(pages_number: 10).call(query)
    urls = serp["search_results"].map { |ser| ser["url"] }
    web_pages = WebPagesFetcherService.new.call(urls)
    web_pages.map { |page| page["content"] }.join(" ")
  end
end
