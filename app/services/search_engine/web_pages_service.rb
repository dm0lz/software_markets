class SearchEngine::WebPagesService < BaseService
  def initialize(search_engine: "duckduckgo", pages_number: 10)
    @search_engine = search_engine
    @pages_number = pages_number
  end
  def call(query)
    serp = SearchEngine::QueryService.new(search_engine: @search_engine, pages_number: @pages_number).call(query)
    urls = serp["search_results"].map { |ser| ser["url"] }
    web_pages = Scraper::WebPagesService.new.call(urls)
    web_pages.map { |page| page["content"] }
  end
end
