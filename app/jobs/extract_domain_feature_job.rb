class ExtractDomainFeatureJob < ApplicationJob
  queue_as :default

  def perform(domain, query)
    relevant_chunks = domain.web_page_chunks_similar_to(query.embedding, 10)
    relevant_chunks_summary = domain.web_pages_summary_similar_to(query.embedding, 10)
    response = Ai::Openai::ChatService.new.call(user_prompt(relevant_chunks.pluck(:content).join(" "), query), response_schema(query))
    summary_response = Ai::Openai::ChatService.new.call(user_prompt(relevant_chunks_summary.pluck(:summary).join(" "), query), response_schema(query))
    domain.update(extracted_content: domain.reload.extracted_content.merge(
      {
        "#{query.search_field}" => response["#{query.search_field}"],
        "#{query.search_field}_summary" => summary_response["#{query.search_field}"]
      }
    ))
  end

  private
  def user_prompt(relevant_chunks, query)
    <<-PROMPT
      Task : Analyze the provided content and answer the question.
      Question : #{query.content}
      Provided content : #{relevant_chunks}
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
