class FetchWebPageContentJob < ApplicationJob
  queue_as :default

  def perform(domain, url)
    return unless results = Scraper::WebPageService.new.call(url)
    web_page = domain.web_pages.find_or_create_by!(url: url)
    web_page.update!(content: results["content"])
  end
end
