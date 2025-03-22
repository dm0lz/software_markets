module ApiAuthentication
  extend ActiveSupport::Concern

  included do
    before_action :authenticate_api_token!
  end

  private

  def authenticate_api_token!
    if api_token = request.headers["Authorization"]&.split(" ")&.last
      user = User.find_by(api_token: api_token)
      Current.api_session = user.api_sessions.create!(user_agent: request.user_agent, ip_address: request.remote_ip) if user
    end

    render json: { error: "Invalid API token." }, status: :unauthorized unless Current.user
  end
end
