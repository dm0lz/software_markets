class ScrapDomainJob < ApplicationJob
  queue_as :default

  def perform(domain)
    results = BrowsePageService.new("http://#{domain.name}", "{}").call(js_code)
    return unless landing_page = domain.web_pages.find_or_initialize_by(url: results["url"]) rescue nil
    landing_page.update(content: results["content"])
    web_pages = FetchWebPagesService.new.call(results["links"])
    web_pages.each do |page|
      web_page = domain.web_pages.find_or_create_by!(url: page["url"]) rescue nil
      next unless web_page
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
