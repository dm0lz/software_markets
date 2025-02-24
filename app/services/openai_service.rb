class OpenaiService
  def call(user_prompt)
    client = OpenAI::Client.new(request_timeout: 300)
    response = client.chat(
      parameters: {
        model: "custom-llama3.2:latest",
        response_format: { type: "json_object" },
        messages: [
          { role: "system", content: system_prompt },
          { role: "user", content: user_prompt }
        ],
        temperature: 0.4
      }
    )
    response["choices"][0]["message"]["content"]
  end

  private
  def system_prompt
    <<-PROMPT
      You must always respond in valid JSON format. Do not include any additional text, explanations, or markdown formatting. Only output JSON.
      Example format:
      {
        "key1": "value1",
        "key2": "value2"
      }
      You analyze the content provided and extract the required information.
      You only respond with structured JSON format.
    PROMPT
  end
end
