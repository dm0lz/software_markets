class AddParametersToApiSessions < ActiveRecord::Migration[8.0]
  def change
    add_column :api_sessions, :request_params, :jsonb
    add_index :api_sessions, :request_params, using: :gin
  end
end
