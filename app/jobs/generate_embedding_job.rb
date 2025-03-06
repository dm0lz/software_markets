class GenerateEmbeddingJob < ApplicationJob
  queue_as :default

  def perform(model)
    embedding = GenerateEmbeddingService.new(model.content).call
    model.update!(embedding: embedding)
  end
end
