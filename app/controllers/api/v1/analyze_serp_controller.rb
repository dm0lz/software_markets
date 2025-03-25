class Api::V1::AnalyzeSerpController < Api::V1::BaseController
  # @summary Analyze search engine results
  # @auth [bearer]
  # @parameter query(query) [!String] The query to search
  # @parameter prompt(query) [!String] The prompt to send to the LLM
  # @parameter search_engine(query) [String] The search engine to use. Supported values: google, bing, yahoo, duckduckgo, yandex
  # @parameter pages_number(query) [Integer] The number of pages to search
  # @response Validation errors(401) [Hash{error: String}]
  # @response Validation errors(403) [Hash{error: String}]
  # @response Validation errors(422) [Hash{error: String}]
  # @request_body The payload to send [!Hash{query: String, prompt: String, search_engine: String, pages_number: Integer}]
  # @request_body_example An example payload [Hash] { "query": "Capital of France", "prompt": "What is the capital of France?", "search_engine": "duckduckgo", "pages_number": 3 }
  def create
    allowed_search_engines = %w[google bing yahoo duckduckgo yandex]

    unless analyze_serp_params[:query]
      return render json: { error: "query is required" }, status: :unprocessable_entity
    end

    unless analyze_serp_params[:prompt]
      return render json: { error: "prompt is required" }, status: :unprocessable_entity
    end

    if analyze_serp_params[:pages_number] && !analyze_serp_params[:pages_number].to_i.positive?
      return render json: { error: "pages number must be a positive integer" }, status: :unprocessable_entity
    end

    if analyze_serp_params[:search_engine] && !allowed_search_engines.include?(analyze_serp_params[:search_engine])
      return render json: { error: "Invalid search_engine. Allowed values: #{allowed_search_engines.join(', ')}" }, status: :unprocessable_entity
    end

    @analysis_output = AnalyzeSerpService.new(
      search_engine: analyze_serp_params[:search_engine] || "duckduckgo",
      pages_number: analyze_serp_params[:pages_number] || 3,
      query: analyze_serp_params[:query]
    ).call(analyze_serp_params[:prompt])
  end

  private
  def analyze_serp_params
    params.permit(:search_engine, :pages_number, :query, :prompt)
  end
end
