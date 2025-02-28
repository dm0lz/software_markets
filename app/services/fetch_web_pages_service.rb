class FetchWebPagesService
  def call(urls)
    cleaned_urls = clean_urls(urls)
    output, error, status = BrowsePagesService.new(cleaned_urls, "{}").call(js_code)
    if status.success?
      JSON.parse(output)
    else
      puts "Error: #{error.strip}"
    end
  end

  private
  def clean_urls(urls)
    urls.map do |url|
      uri = URI.parse(url)
      uri.is_a?(URI::HTTP) || uri.is_a?(URI::HTTPS) ? uri.to_s : nil
    end.compact
  end

  def js_code
    <<-JS
      return {
        url: document.location.href,
        content: document.body.innerText
      }
    JS
  end
end
