class Api::V1::ScrapDomainController < Api::V1::BaseController
  # @summary Scrap domain
  # @auth [bearer]
  # @parameter domain(query) [!String] The domain to scrap
  # @parameter js_script(query) [String] The javascript code to execute on the page
  # @response Validation errors(401) [Hash{error: String}]
  # @response Validation errors(403) [Hash{error: String}]
  # @response Validation errors(422) [Hash{error: String}]
  # @request_body The payload to send [!Hash{domain: String, js_script: String}]
  # @request_body_example An example payload [Hash] { "domain": "skuuudle.com", "js_script": "return { url:  document.location.href, content: document.body.innerText }" }
  def create
    unless valid_domain?
      return render json: { error: "valid domain is required" }, status: :unprocessable_entity
    end

    web_page = Scraper::WebPageService.new("http://#{web_page_params[:domain]}").call(js_code)
    scraper = Scraper::WebPagesService.new(web_page["links"])
    @web_pages = scraper.call(web_page_params[:js_script] || "return { url:  document.location.href, content: document.body.innerText }")
  end

  private
  def web_page_params
    params.permit(:domain, :js_script)
  end

  def valid_domain?
    web_page_params[:domain].present? && PublicSuffix.valid?(web_page_params[:domain])
  end

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
