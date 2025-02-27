module Public
  class DomainsController < ApplicationController
    def index
      @domains = Domain.all
    end

    def show
      @domain = Domain.find_by(name: "#{params[:id]}.#{params[:format]}")
    end
  end
end
