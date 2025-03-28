class RetrieveCompaniesDomainJob < ApplicationJob
  queue_as :default

  def perform(companies, batch_nb)
    queries(companies).each_slice(batch_nb) do |batch|
      results = SearchEngine::Provider::Bulk::DuckduckgoService.new.call(batch)
      results.each do |result|
        company_name = CGI.unescape(result["serp_url"]).match(/q=([^\&]+)\sOfficial/)[1] rescue next
        domain = matching_domain(result["search_results"], company_name) || recurring_domain(result["search_results"])
        company = Company.find_by(name: company_name)
        next logger.error(result["serp_url"]) unless company
        company.domains.update_all(name: PublicSuffix.domain(domain))
        logger.info company.name
        logger.info PublicSuffix.domain(domain)
      end
    end
  end

  private
  def queries(companies)
    # companies = Company.joins(:domains).where(domains: { name: nil }).take(3000)
    companies.map do |company|
      company_name = company.name.downcase.gsub("'", "")
      "#{company_name}+Official+Website"
    end
  end

  def matching_domain(search_results, company_name)
    match = search_results.find { |ser| ser["site_name"].downcase == company_name }
    URI.parse(match["url"]).host rescue nil
  end

  def recurring_domain(search_results)
    search_results
      .group_by { |ser| URI.parse(ser["url"]).host }
      .transform_values(&:count)
      .max_by { |_, v| v }
      .first rescue nil
  end
end
