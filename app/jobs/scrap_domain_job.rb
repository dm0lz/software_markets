class ScrapDomainJob < ApplicationJob
  queue_as :default

  def perform(domain)
    output, error, status = BrowsePageService.new("http://#{domain.name.sub("https://", "")}", "{}").call(js_code)
    if status.success?
      results = JSON.parse(output)
      domain.web_pages.create!(url: results["url"], content: results["content"])
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
        content: document.body.innerText
      }
    JS
  end
end
