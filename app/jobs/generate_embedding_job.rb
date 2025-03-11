class GenerateEmbeddingJob < ApplicationJob
  queue_as :default
  queue_with_priority 1

  def perform(model)
    embedding = OpenaiEmbeddingService.new(model.public_send(model.class.embedding_source_column)).call
    model.update!("#{model.class.embedding_target_column}": embedding)
  end
end
