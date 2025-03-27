class SearchEngine::Provider::GoogleService < BaseService
  def initialize(pages_number: 10, options: "{}")
    @pages_number = pages_number
    @options = options
  end

  def call(query)
    url = URI("http://#{ENV.fetch('GOOGLE_SERP_HOST', 'localhost')}:3001/api/search?q=#{query}&pages_nb=#{@pages_number}")
    response = Net::HTTP.get(url)
    data = JSON.parse(response)
    data.map { |serp| serp["search_results"] }.flatten
  end
end
