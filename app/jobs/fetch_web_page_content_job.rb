class FetchWebPageContentJob < ApplicationJob
  queue_as :default

  def perform(url)
    return unless valid_url?(url)

    output, error, status = BrowsePageService.new(url, "{}").call(js_code)
    if status.success?
      results = JSON.parse(output)
      domain = Domain.find_by(name: URI.parse(url).host)
      web_page = domain.web_pages.find_or_create_by!(url: url)
      web_page.update!(content: results["content"])
      logger.info "Successfully updated content of web_page for #{url}"
    else
      logger.error "Error: #{error.strip}"
    end
  end

  private
  def valid_url?(url)
    uri = URI.parse(url)
    uri.is_a?(URI::HTTP) || uri.is_a?(URI::HTTPS)
  rescue URI::InvalidURIError
    logger.error "Invalid URL format: #{url}"
    false
  end

  def js_code
    <<-JS
      return {
        content: document.body.innerText
      }
    JS
  end
end
