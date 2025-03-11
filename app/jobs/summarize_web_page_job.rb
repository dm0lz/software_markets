class SummarizeWebPageJob < ApplicationJob
  queue_as :default

  def perform(web_page)
    response = OpenaiChatService.new.call(user_prompt(web_page), response_schema)
    web_page.update!(summary: response["summary"])
  end

  private
  def user_prompt(web_page)
    <<-PROMPT
      Task : Summarize the web page and extract every available detail about the company and the products and services.
      Web page content : #{web_page.content}
    PROMPT
  end

  def response_schema
    {
      "strict": true,
      "name": "summarization",
      "description": "summarize the web page",
      "schema": {
        "type": "object",
        "properties": {
          "summary": {
            "type": "string",
            "description": "Summary of the web page."
          }
        },
        "additionalProperties": false,
        "required": [ "summary" ]
      }
    }
  end
end
