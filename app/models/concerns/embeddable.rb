module Embeddable
  extend ActiveSupport::Concern

  included do
    after_save :generate_embedding, if: -> { saved_change_to_content? }
  end

  def generate_embedding
    GenerateEmbeddingJob.perform_later(self)
  end
end
