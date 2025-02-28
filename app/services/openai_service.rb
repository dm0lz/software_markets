class OpenaiService < BaseService
  def call(user_prompt, response_schema)
    client = OpenAI::Client.new(request_timeout: 600)
    response = client.chat(
      parameters: {
        model: "custom-deepseek-r1:latest",
        # response_format: { type: "json_object" },
        response_format: {
          type: "json_schema",
          json_schema: response_schema
        },
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
      You must always respond in valid JSON format.
      Do not include any additional text, explanations, or markdown formatting.
      You analyze the content provided and extract the required information.
      You only respond with structured JSON format.
    PROMPT
  end
end
