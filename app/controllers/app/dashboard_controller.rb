module App
  class DashboardController < ApplicationController
    def index
      @user = Current.user
    end
  end
end
