class AddEndpointToApiSessions < ActiveRecord::Migration[8.0]
  def change
    add_column :api_sessions, :endpoint, :string
  end
end
