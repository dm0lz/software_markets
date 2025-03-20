# Company.joins(:domains).where.not(domains: {name: nil}).count
# Company.joins(:domains).where(domains: {name: nil}).each{|l| RetrieveCompanyDomainJob.perform_later(l)}
class FindCompanyDomainJob < ApplicationJob
  queue_as :default

  def perform(company)
    serp = SerpFetcher::SearchEngineResultsCreatorService.new.call(company.name)
    domain = SerpDomainExtractorService.new.call(serp)
    logger.info "#{company.name} - #{domain}"
    company.domains.find_or_create_by!(name: domain)
  end
end
