class ScrapCapterraMarketCompaniesJob < ApplicationJob
  CAPTERRA_BASE_URL = "https://www.capterra.fr".freeze
  queue_as :default

  def perform(market_provider)
    process_page(market_provider, market_provider.market_url)
    if @page_number && @page_number.to_i > 1
      (2..@page_number.to_i).to_a.each do |page|
        process_page(market_provider, "#{market_provider.market_url}?page=#{page}")
      end
    end
  end

  private
  def process_page(market_provider, url)
    return unless market = PageBrowserService.new(url).call(parse_market)
    update_market_data(market_provider, market)
    create_companies(market_provider, market)
    @page_number = market["capterra_market"]["pages_number"] unless @page_number
  end

  def update_market_data(market_provider, market)
    market_description = market["capterra_market"]["description"]
    competitors_count = market["capterra_market"]["competitors_count"]
    market_provider.update!(description: market_description, competitors_count: competitors_count) unless market_provider.description
  end

  def create_companies(market_provider, capterra_market)
    capterra_market["capterra_market"]["software_applications"].each do |software|
      begin
        market = market_provider.market
        company = Company.find_or_create_by!(name: software["name"].downcase)
        market.companies << company unless market.companies.include?(company)
        domain = create_domain(company, software["redirect_url"])
        create_software_application(domain, software)
      rescue StandardError => e
        logger.error "Failed to process company #{software['name']}: #{e.message}"
      end
    end
  end

  def create_software_application(domain, software)
    domain.software_applications.find_or_create_by!(
      name: software["name"],
      description: software["description"],
      provider_url: software["capterra_url"],
      provider_redirect_url: software["redirect_url"],
      rating: software["rating"].sub(",", ".").to_f,
      rating_count: software["rating_count"].to_i
    )
  end

  def create_domain(company, redirect_url)
    example_domain = { "domain" => "example.com" }
    fetched_domain = if redirect_url == "#"
      example_domain
    else
      PageBrowserService.new("#{CAPTERRA_BASE_URL}#{redirect_url}", playwright_options).call(get_domain) || example_domain
    end
    company.domains.find_or_create_by!(name: fetched_domain["domain"])
  end

  def parse_market
    <<-JS
      return {
        capterra_market: {
          description: document.querySelector("#secondaryHeader > div.container.pb-3 > div > div > p")?.textContent.replace(/\s+/g, " ").trim().replace(/Lire la suite|Afficher moins/g, ""),
          pages_number: document.querySelectorAll(".page-item")[document.querySelectorAll(".page-item").length - 2]?.textContent.trim(),
          competitors_count: document.querySelector("#categoryFilterOffcanvas > div > div.flex-grow-0.text-charcoal.px-3.px-lg-0.pb-3.pb-lg-4 > div")?.textContent.match(/\((\d+)\)/)?.[1] || "0",
          software_applications: Array.from(document.querySelectorAll(".product-card")).map(item => ({
            name: item.querySelector(".h5.fw-bold.mb-2")?.textContent.trim() || "N/A",
            description: item.querySelector(".d-none.d-lg-block")?.textContent.trim() || "N/A",
            rating: item.querySelector("span.ms-1")?.textContent.trim() || "0",
            rating_count: item.querySelector(".star-rating-component > span:nth-child(2)")?.textContent.trim().replace("(", "").replace(")", "") || "0",
            capterra_url: item.querySelector("a.fw-bold.event")?.getAttribute("href") || "#",
            redirect_url: item.querySelector("a.btn.btn-preferred.w-100.d-inline-flex.align-items-center.justify-content-center.event")?.getAttribute("href") || "#"
          }))
        }
      }
    JS
  end

  def get_domain
    <<-JS
      return {
        domain: document.location.hostname
      }
    JS
  end

  def playwright_options
    <<-JS
      { headless: true, waitUntil: "networkidle", slowMo: 5000 }
    JS
  end
end
