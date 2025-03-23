class Api::V1::DomainEmailsController < Api::V1::BaseController
  # @summary Get emails from domain
  # @auth [bearer]
  # @parameter domain(query) [!String] The domain to search
  # @parameter search_engine(query) [String] The search engine to use. Supported values: google, bing, yahoo, duckduckgo, yandex
  # @parameter pages_number(query) [Integer] The number of pages to search
  # @response Validation errors(401) [Hash{error: String}]
  # @response Validation errors(403) [Hash{error: String}]
  # @response Validation errors(422) [Hash{error: String}]
  def index
    unless valid_domain?
      return render json: { error: "valid domain name is required" }, status: :unprocessable_entity
    end

    allowed_search_engines = %w[google bing yahoo duckduckgo yandex]
    if email_params[:search_engine] && !allowed_search_engines.include?(email_params[:search_engine])
      return render json: { error: "Invalid search_engine. Allowed values: #{allowed_search_engines.join(', ')}" }, status: :unprocessable_entity
    end

    if email_params[:pages_number] && !email_params[:pages_number].to_i.positive?
      return render json: { error: "pages number must be a positive integer" }, status: :unprocessable_entity
    end

    @emails = SearchEngine::DomainEmailsFinderService.new(
      search_engine: email_params[:search_engine] || "duckduckgo",
      pages_number: email_params[:pages_number] || 3
    ).call(params.require(:domain))
  end

  private
  def valid_domain?
    email_params[:domain].present? && email_params[:domain].match?(/\A[a-zA-Z0-9][a-zA-Z0-9-]{1,61}[a-zA-Z0-9]\.[a-zA-Z]{2,}\z/)
  end

  def email_params
    params.permit(:search_engine, :pages_number, :domain)
  end
end
