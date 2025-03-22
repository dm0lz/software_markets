class SearchEngine::QueryService < BaseService
  def initialize(search_engine: "duckduckgo", pages_number: 10, options: "{}")
    @search_engine = search_engine
    @pages_number = pages_number
    @options = options
  end
  def call(query)
    serp = "SearchEngine::Provider::#{@search_engine.capitalize}Service".constantize.new(pages_number: @pages_number, options: @options).call(query)
    serp.reject { |ser| ser.any? { |_, value| value == "N/A" } }
  end
end
