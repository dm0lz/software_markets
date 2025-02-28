class ScrapCapterraMarketsJob < ApplicationJob
  queue_as :default

  def perform(url)
    markets = BrowsePageService.new(url, "{}").call(js_code)
    logger.info output
    provider = Provider.find_or_create_by!(name: "Capterra", domain: "capterra.fr")
    markets["capterra_markets"].map do |capterra_market|
      en_market = capterra_market["url"].split("/")[-2].gsub("-", " ")
      market = Market.find_or_create_by!(name: en_market)
      provider.market_providers.find_or_create_by!(market: market, market_name: capterra_market["name"], market_url: capterra_market["url"])
    end
    logger.info "#{provider.markets.count} Capterra markets have been scraped successfully."
  end

  private
  def js_code
    <<-JS
      return {
        capterra_markets: Array.from(document.querySelectorAll(".list-group-item")).map(item => ({
          name: item.textContent.trim(),
          url: item.getAttribute("href")
        }))
      }
    JS
  end
end
