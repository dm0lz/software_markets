class Api::V1::HfModelsController < Api::V1::BaseController
  # @summary Hugging Face models list
  # @auth [bearer]
  # @parameter task(query) [!String] The task. Supported values: "any-to-any", "audio-classification", "audio-to-audio", "audio-text-to-text", "automatic-speech-recognition", "depth-estimation", "document-question-answering", "visual-document-retrieval", "feature-extraction", "fill-mask", "image-classification", "image-feature-extraction", "image-segmentation", "image-to-image", "image-text-to-text", "image-to-text", "keypoint-detection", "mask-generation", "object-detection", "video-classification", "question-answering", "reinforcement-learning", "sentence-similarity", "summarization", "table-question-answering", "tabular-classification", "tabular-regression", "text-classification", "text-generation", "text-to-image", "text-to-speech", "text-to-video", "token-classification", "translation", "unconditional-image-generation", "video-text-to-text", "visual-question-answering", "zero-shot-classification", "zero-shot-image-classification", "zero-shot-object-detection", "text-to-3d", "image-to-3d"
  # @parameter limit(query) [Integer] The limit of models to return. Default: 30
  # @response Validation errors(401) [Hash{error: String}]
  # @response Validation errors(403) [Hash{error: String}]
  # @response Validation errors(422) [Hash{error: String}]
  def index
    allowed_tasks = Ai::HuggingFace::ModelsService.new.tasks.keys
    @task = hf_models_params[:task]
    unless allowed_tasks.include?(@task)
      return render json: { error: "Invalid task. Allowed values: #{allowed_tasks.join(', ')}" }, status: :unprocessable_entity
    end
    @models = Ai::HuggingFace::ModelsService.new.call(@task, hf_models_params[:limit] || 30)
  end

  private
  def hf_models_params
    params.permit(:task, :limit)
  end
end
