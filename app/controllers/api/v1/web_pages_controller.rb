class Api::V1::WebPagesController < Api::V1::BaseController
  # @summary Scrap web pages
  # @auth [bearer]
  # @parameter urls(query) [!Array<String>] The urls to scrap
  # @parameter js_script(query) [String] The javascript code to execute on the page
  # @response Validation errors(401) [Hash{error: String}]
  # @response Validation errors(403) [Hash{error: String}]
  # @response Validation errors(422) [Hash{error: String}]
  # @request_body The payload to send [!Hash{urls: Array<String>, js_script: String}]
  # @request_body_example An example payload [Hash] { "urls": ["https://taboola.com", "https://google.com"], "js_script": "return { url: document.location.href, content: document.body.innerText }" }
  def create
    unless valid_urls?
      return render json: { error: "valid urls are required" }, status: :unprocessable_entity
    end

    scraper = Scraper::WebPagesService.new(web_pages_params[:urls])
    @web_pages = scraper.call(web_pages_params[:js_script] || "return { content: document.body.innerText }")
  end

  private
  def web_pages_params
    params.permit(:js_script, urls: [])
  end

  def valid_urls?
    web_pages_params[:urls].present? && web_pages_params[:urls].all? { |url| url =~ URI::DEFAULT_PARSER.make_regexp }
  end
end
