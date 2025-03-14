class Public::ApplicationController < ApplicationController
  allow_unauthenticated_access
  before_action :set_session_id
  attr_reader :session_id

  private
  def set_session_id
    @session_id = cookies.encrypted["_software_markets_session"]["session_id"] rescue nil
  end
end
