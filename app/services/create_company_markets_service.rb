class CreateCompanyMarketsService < BaseService
  def call
    Company.all.each do |company|
      begin
        next if CompanyMarket.find_by(company_id: company.id) or Company.find_by(id: company.id).nil?
        duplicated_companies = Company.where(name: company.name)
        markets = duplicated_companies.map { |l| l.market }
        markets.each do |market|
          CompanyMarket.create!(company: company, market: market)
        end
        duplicated_companies.each do |duplicates|
          duplicates.destroy! unless duplicates == company
        end
      rescue StandardError => e
        binding.pry
      end
    end
  end
end
