class FetchWebPageService
  def call(url)
    return unless valid_url?(url)
    output, error, status = BrowsePageService.new(url, "{}").call(js_code)
    if status.success?
      JSON.parse(output)
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
