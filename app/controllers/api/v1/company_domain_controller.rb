class Api::V1::CompanyDomainController < Api::V1::BaseController
  # @summary Get domain from company name
  # @auth [bearer]
  # @parameter company(query) [!String] The company to search
  # @parameter search_engine(query) [String] The search engine to use. Supported values: google, bing, yahoo, duckduckgo, yandex
  # @parameter pages_number(query) [Integer] The number of pages to search
  # @response Validation errors(401) [Hash{error: String}]
  # @response Validation errors(403) [Hash{error: String}]
  # @response Validation errors(422) [Hash{error: String}]
  def index
    unless company_domain_params[:company].present?
      return render json: { error: "Company name is required" }, status: :unprocessable_entity
    end

    allowed_search_engines = %w[google bing yahoo duckduckgo yandex]
    if company_domain_params[:search_engine] && !allowed_search_engines.include?(company_domain_params[:search_engine])
      return render json: { error: "Invalid search_engine. Allowed values: #{allowed_search_engines.join(', ')}" }, status: :unprocessable_entity
    end

    if company_domain_params[:pages_number] && company_domain_params[:pages_number].to_i.positive?
      return render json: { error: "pages number must be a positive integer" }, status: :unprocessable_entity
    end

    @domain = SearchEngine::CompanyDomainFinderService.new(
      search_engine: company_domain_params[:search_engine] || "duckduckgo",
      pages_number: company_domain_params[:pages_number] || 3
    ).call(company_domain_params[:company])
  end

  private
  def company_domain_params
    params.permit(:search_engine, :pages_number, :company)
  end
end
