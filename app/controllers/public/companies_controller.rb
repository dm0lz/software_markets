module Public
  class CompaniesController < ApplicationController
    def index
      @companies = Company.all
    end

    def show
      @company = Company.find_by(name: params[:id].gsub("-", " "))
      @domains = @company.domains
    end
  end
end
