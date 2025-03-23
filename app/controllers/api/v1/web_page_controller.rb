class Api::V1::WebPageController < Api::V1::BaseController
  # @summary Scrap web page
  # @auth [bearer]
  # @parameter url(query) [!String] The url to scrap
  # @parameter js_script(query) [String] The javascript code to execute on the page
  # @response Validation errors(401) [Hash{error: String}]
  # @response Validation errors(403) [Hash{error: String}]
  # @response Validation errors(422) [Hash{error: String}]
  # @request_body The payload to send [!Hash{url: String, js_script: String}]
  # @request_body_example An example payload [Hash] { "url": "https://taboola.com", "js_script": "return { content: document.body.innerText }" }
  def create
    unless valid_url?
      return render json: { error: "valid url is required" }, status: :unprocessable_entity
    end

    scraper = Scraper::WebPageService.new(web_page_params[:url])
    @web_page = scraper.call(web_page_params[:js_script] || "return { content: document.body.innerText }")
  end

  private
  def web_page_params
    params.permit(:url, :js_script)
  end

  def valid_url?
    web_page_params[:url].present? && web_page_params[:url] =~ URI::DEFAULT_PARSER.make_regexp
  end
end
