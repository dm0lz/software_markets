require "openai"
OpenAI.configure do |config|
  config.access_token = "not-needed"
  config.uri_base = "http://#{ENV.fetch("OLLAMA_IP") { "localhost" }}:11434/v1"
  config.log_errors = true # Highly recommended in development, so you can see what errors OpenAI is returning. Not recommended in production because it could leak private data to your logs.
end
