# Company.joins(:domains).where.not(domains: {name: nil}).count
# Company.joins(:domains).where(domains: {name: nil}).each{|l| RetrieveCompanyDomainJob.perform_later(l)}
class FindCompanyDomainJob < ApplicationJob
  queue_as :default

  def perform(company)
    results = SerpFetcher::DispatcherService.new(search_engine: "duckduckgo", pages_number: 10).call(company.name)
    serp = results["search_results"]
    domain = Ai::SerpDomainExtractorService.new.call(serp)
    logger.info "#{company.name} - #{domain}"
    company.domains.find_or_create_by!(name: domain)
  end
end
