module Public
  class MarketsController < ApplicationController
    def index
      @markets = Market.all
    end

    def show
      @market = Market.find_by(name: params[:id].gsub("-", " "))
      @companies = @market.companies
    end
  end
end
