class SummarizeTextService < BaseService
  def call(text)
    ExecutePythonScriptService.new.call(python_script(text))
  end

  private
  def python_script(text)
    <<-PYTHON
      import json
      from transformers import AutoTokenizer, AutoModelForSeq2SeqLM
      tokenizer = AutoTokenizer.from_pretrained("Falconsai/text_summarization")
      model = AutoModelForSeq2SeqLM.from_pretrained("Falconsai/text_summarization")
      inputs = tokenizer("#{text.gsub(/[\n']/, " ")}", return_tensors="pt", truncation=True, padding=True)
      summary_ids = model.generate(inputs["input_ids"], max_length=1024)
      summary = tokenizer.decode(summary_ids[0], skip_special_tokens=True)
      print(json.dumps({"summary": summary}, indent=2))
    PYTHON
  end
end
