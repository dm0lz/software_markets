class RetrieveMarketsSearchEngineResultsJob < ApplicationJob
  queue_as :default

  def perform
    queries = Market.all.map do |market|
      "#{market.name} Software"
    end
    results = FetchSerpsService.new(pages_number: 15).call(queries)
    results.each do |result|
      result["search_results"].each do |ser|
        SearchEngineResult.create!(
          query: result["serp_url"],
          site_name: ser["site_name"],
          title: ser["title"],
          url: ser["url"],
          description: ser["description"],
          position: ser["position"]
        )
      end
    end
  end
end
