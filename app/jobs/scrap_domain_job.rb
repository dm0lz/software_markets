class ScrapDomainJob < ApplicationJob
  queue_as :default

  def perform(domain)
    output, error, status = BrowsePageService.new("http://#{domain.name}", "{}").call(js_code)
    if status.success?
      results = JSON.parse(output)
      domain.web_pages.find_or_create_by!(url: results["url"], content: results["content"])
      results["links"].each do |link|
        FetchWebPageContentJob.perform_later(link)
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
          [...document.querySelectorAll('a[href]')]
            .map(a => a.href)
            .filter(href => href.startsWith(location.origin))
        )];
      }
    JS
  end
end
