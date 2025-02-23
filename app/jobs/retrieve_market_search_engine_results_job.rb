class RetrieveMarketSearchEngineResultsJob < ApplicationJob
  queue_as :default

  def perform(market)
    query = "#{market.name} Software"
    results = FetchSerpService.new(pages_number: 15).call(query)
    results = results["search_results"]
    results.each do |result|
      SearchEngineResult.create!(
        query: query,
        site_name: result["site_name"],
        title: result["title"],
        url: result["url"],
        description: result["description"],
        position: result["position"]
      )
    end
  end
end
