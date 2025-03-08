class Admin::ApplicationController < ApplicationController
  before_action :authorize_admin

  private
  def authorize_admin
    redirect_to main_app.app_root_path unless Current.user&.is_admin?
  end
end
