class ScrapDomainJob < ApplicationJob
  queue_as :default

  def perform(domain)
    output, error, status = BrowsePageService.new("http://#{domain.name}", "{}").call(js_code)
    if status.success?
      results = JSON.parse(output)
      web_page = domain.web_pages.find_or_initialize_by(url: results["url"])
      web_page.update(content: results["content"])
      results["links"].each do |link|
        FetchWebPageContentJob.perform_later(domain, link)
      end
      logger.info "Successfully scraped domain #{domain.name}"
    else
      logger.error "Error: #{error.strip}"
    end
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
