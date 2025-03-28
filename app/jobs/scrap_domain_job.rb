class ScrapDomainJob < ApplicationJob
  queue_as :default
  queue_with_priority 3

  def perform(domain)
    results = Scraper::PageEvaluatorService.new("http://#{domain.name}").call(js_code)
    landing_page = domain.web_pages.find_or_initialize_by(url: results["url"])
    landing_page.update(content: results["content"])
    web_pages = Scraper::WebPagesService.new(results["links"]).call
    web_pages.each do |page|
      web_page = domain.web_pages.find_or_initialize_by(url: page["url"])
      web_page.update!(content: page["content"])
    end
    logger.info "Successfully scraped domain #{domain.name}"
  end

  private
  def js_code
    <<-JS
      return {
        url:  document.location.href,
        content: document.body.innerText,
        links: [...new Set(
          [...document.querySelectorAll("a[href]")]
            .map(a => a.href)
            .filter(href => href.startsWith(location.origin))
        )]
      }
    JS
  end
end
