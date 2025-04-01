class Api::V1::AnalyzeWebPageController < Api::V1::BaseController
  # @summary Analyze web page
  # @auth [bearer]
  # @parameter url(query) [!String] The url to analyze
  # @parameter prompt(query) [!String] The prompt to use
  # @response Validation errors(401) [Hash{error: String}]
  # @response Validation errors(403) [Hash{error: String}]
  # @response Validation errors(422) [Hash{error: String}]
  # @request_body The payload to send [!Hash{url: String, prompt: String}]
  # @request_body_example An example payload [Hash] { "url": "https://taboola.com", "prompt": "What are the products or services offered by Taboola?" }
  def create
    unless @prompt = analyze_web_page_params[:prompt]
      return render json: { error: "prompt is required" }, status: :unprocessable_entity
    end

    unless valid_url?
      return render json: { error: "valid url is required" }, status: :unprocessable_entity
    end

    @analysis_output = WebPageAnalyzerService.new(analyze_web_page_params[:url]).call(@prompt)
  end

  private
  def analyze_web_page_params
    params.permit(:url, :prompt)
  end

  def valid_url?
    analyze_web_page_params[:url].present? && analyze_web_page_params[:url] =~ URI::DEFAULT_PARSER.make_regexp
  end
end
