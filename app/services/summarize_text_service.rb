class SummarizeTextService < BaseService
  def call(text)
    HuggingFaceService.new("summarization", "sshleifer/distilbart-cnn-12-6").call(text)[0]
  end
end
