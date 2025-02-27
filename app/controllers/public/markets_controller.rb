module Public
  class MarketsController < ApplicationController
    def index
      @markets = Market.all
    end

    def show
      @market = Market.find(params[:id])
      @companies = @market.companies
    end
  end
end
