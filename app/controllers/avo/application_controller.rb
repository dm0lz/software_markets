# app/controllers/avo/application_controller.rb
module Avo
  class ApplicationController < BaseApplicationController
    include Authentication
    delegate :new_session_path, to: :main_app

    # we are prepending the action to ensure it will be fired very early on in the request lifecycle
    prepend_before_action :require_authentication
    before_action :authorize_admin

    private
    def authorize_admin
      redirect_to main_app.app_root_path unless Current.user&.is_admin?
    end
  end
end
