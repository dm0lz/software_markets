class Api::V1::HfInferenceController < Api::V1::BaseController
  # @summary Hugging Face inference
  # @auth [bearer]
  # @parameter input(query) [!String] The input text to process
  # @parameter task(query) [!String] The task to perform. Supported values: "any-to-any", "audio-classification", "audio-to-audio", "audio-text-to-text", "automatic-speech-recognition", "depth-estimation", "document-question-answering", "visual-document-retrieval", "feature-extraction", "fill-mask", "image-classification", "image-feature-extraction", "image-segmentation", "image-to-image", "image-text-to-text", "image-to-text", "keypoint-detection", "mask-generation", "object-detection", "video-classification", "question-answering", "reinforcement-learning", "sentence-similarity", "summarization", "table-question-answering", "tabular-classification", "tabular-regression", "text-classification", "text-generation", "text-to-image", "text-to-speech", "text-to-video", "token-classification", "translation", "unconditional-image-generation", "video-text-to-text", "visual-question-answering", "zero-shot-classification", "zero-shot-image-classification", "zero-shot-object-detection", "text-to-3d", "image-to-3d"
  # @parameter model(query) [!String] The Hugging Face mode to use
  # @response Validation errors(401) [Hash{error: String}]
  # @response Validation errors(403) [Hash{error: String}]
  # @response Validation errors(422) [Hash{error: String}]
  # @request_body The payload to send [!Hash{input: String, task: String, model: String}]
  # @request_body_example An example payload [Hash] { "task": "summarization", "model": "sshleifer/distilbart-cnn-12-6", input: "The quick brown fox jumps over the lazy dog" }
  def create
    unless @input = hf_inference_params[:input]
      return render json: { error: "analysis input is required" }, status: :unprocessable_entity
    end

    allowed_tasks = Ai::HuggingFace::ModelsService.new.tasks.keys
    @task = hf_inference_params[:task]
    unless allowed_tasks.include?(@task)
      return render json: { error: "Invalid task. Allowed values: #{allowed_tasks.join(', ')}" }, status: :unprocessable_entity
    end

    @model = hf_inference_params[:model]
    @output = Ai::HuggingFace::PipelineService.new(hf_inference_params[:task], hf_inference_params[:model]).call(hf_inference_params[:input])
  end

  private
  def hf_inference_params
    params.permit(:input, :task, :model)
  end
end
