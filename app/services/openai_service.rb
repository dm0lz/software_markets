class OpenaiService
  def call(prompt)
    client = OpenAI::Client.new(request_timeout: 300)
    response = client.chat(
      parameters: {
        model: "openai/llama-3.2-3b-instruct",
        messages: [
          { role: "system", content: "You are a helpful assistant." },
          { role: "user", content: prompt }
        ],
        temperature: 0.7
      }
    )
    response["choices"][0]["message"]["content"]
  end
end
