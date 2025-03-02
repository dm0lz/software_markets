class FetchWebPageService < BaseService
  def call(url)
    return unless valid_url?(url)
    BrowsePageService.new(url, "{}").call(js_code.strip)
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
