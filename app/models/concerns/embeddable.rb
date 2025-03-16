module Embeddable
  extend ActiveSupport::Concern

  included do
    class_attribute :embedding_source_column, default: :content
    class_attribute :embedding_target_column, default: :embedding

    after_save :generate_embedding, if: -> { saved_change_to_attribute?(embedding_source_column) }
  end

  class_methods do
    def embeddable(source_column:, target_column:)
      self.embedding_source_column = source_column
      self.embedding_target_column = target_column
    end
  end

  def generate_embedding
    GenerateEmbeddingJob.perform_later(self)
  end
end
