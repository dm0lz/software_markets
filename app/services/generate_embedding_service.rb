class GenerateEmbeddingService < BaseService
  def initialize(text)
    @text = text
  end

  def call
    client = OpenAI::Client.new(request_timeout: 900)
    response = client.embeddings(
      parameters: {
        model: "custom-deepseek-r1:latest",
        input: @text,
        temperature: 0.2
      }
    )
    response["data"][0]["embedding"]
  end
end
