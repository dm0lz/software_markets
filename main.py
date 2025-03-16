import json
from transformers import AutoTokenizer, AutoModelForSeq2SeqLM

model_name = "Falconsai/text_summarization"
tokenizer = AutoTokenizer.from_pretrained(model_name)
model = AutoModelForSeq2SeqLM.from_pretrained(model_name)

inputs = tokenizer("test", return_tensors="pt", truncation=True, padding=True)
summary_ids = model.generate(inputs["input_ids"], max_length=50)
summary = tokenizer.decode(summary_ids[0], skip_special_tokens=True)

print(json.dumps({"summary": summary}, indent=2))
