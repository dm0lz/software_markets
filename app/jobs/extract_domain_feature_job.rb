class ExtractDomainFeatureJob < ApplicationJob
  queue_as :default

  def perform(domain, query)
    relevant_chunks = domain.web_page_chunks_similar_to(query.embedding)
    response = OpenaiChatService.new.call(user_prompt(relevant_chunks, query), response_schema(query))
    json = JSON.parse(response.match(/{.*}/m).to_s) rescue nil
    domain.update(extracted_content: domain.extracted_content.merge(
      { "#{query.search_field}" => json["#{query.search_field}"] }
    ))
  end

  private
  def user_prompt(relevant_chunks, query)
    <<-PROMPT
      Task : Analyze the provided content and answer the question.
      Question : #{query.content}
      Provided content : #{relevant_chunks.pluck(:content).join(" ")}
    PROMPT
  end

  def response_schema(query)
    {
      "strict": true,
      "name": "query_extraction",
      "description": "Extract information from provided content",
      "schema": {
        "type": "object",
        "properties": {
          "#{query.search_field}": {
            "type": "string",
            "description": "#{query.content}"
          }
        },
        "additionalProperties": false,
        "required": [ "#{query.search_field}" ]
      }
    }
  end
end
