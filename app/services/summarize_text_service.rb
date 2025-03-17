class SummarizeTextService < BaseService
  def call(text)
    ExecutePythonScriptService.new.call(python_script(text))
  end

  private
  def python_script(text)
    <<-PYTHON
      import json
      from transformers import AutoTokenizer, AutoModelForSeq2SeqLM

      # model_name= "sshleifer/distilbart-cnn-12-6"
      # model_name = "facebook/bart-large-cnn"
      # model_name = "google/pegasus-xsum"
      model_name = "Falconsai/text_summarization"

      tokenizer = AutoTokenizer.from_pretrained(model_name)
      model = AutoModelForSeq2SeqLM.from_pretrained(model_name)

      inputs = tokenizer("#{text.gsub(/[\n']/, " ")}", return_tensors="pt", truncation=True, padding=True)
      summary_ids = model.generate(inputs["input_ids"], max_length=1024)
      summary = tokenizer.decode(summary_ids[0], skip_special_tokens=True)

      print(json.dumps({"summary": summary}, indent=2))
    PYTHON
  end
end
