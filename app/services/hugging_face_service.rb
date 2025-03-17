class HuggingFaceService < BaseService
  def initialize(task, model)
    @task = task
    @model = model
  end

  def call(input)
    ExecutePythonScriptService.new.call(python_script(input))
  end

  private
  def python_script(input)
    <<-PYTHON
      import json
      from transformers import pipeline

      pipe = pipeline("#{@task}", model="#{@model}")
      result = pipe("#{input}")

      print(json.dumps(result, indent=2))
    PYTHON
  end

  def tasks
    [
      "any-to-any",
      "audio-classification",
      "audio-to-audio",
      "audio-text-to-text",
      "automatic-speech-recognition",
      "depth-estimation",
      "document-question-answering",
      "visual-document-retrieval",
      "feature-extraction",
      "fill-mask",
      "image-classification",
      "image-feature-extraction",
      "image-segmentation",
      "image-to-image",
      "image-text-to-text",
      "image-to-text",
      "keypoint-detection",
      "mask-generation",
      "object-detection",
      "video-classification",
      "question-answering",
      "reinforcement-learning",
      "sentence-similarity",
      "summarization",
      "table-question-answering",
      "tabular-classification",
      "tabular-regression",
      "text-classification",
      "text-generation",
      "text-to-image",
      "text-to-speech",
      "text-to-video",
      "token-classification",
      "translation",
      "unconditional-image-generation",
      "video-text-to-text",
      "visual-question-answering",
      "zero-shot-classification",
      "zero-shot-image-classification",
      "zero-shot-object-detection",
      "text-to-3d",
      "image-to-3d"
    ]
  end
end
