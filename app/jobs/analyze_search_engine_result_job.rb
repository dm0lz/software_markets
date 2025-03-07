class AnalyzeSearchEngineResultJob < ApplicationJob
  queue_as :default

  def perform(search_engine_result)
    response = OpenaiChatService.new.call(user_prompt(search_engine_result), response_schema(search_engine_result))
    logger.info response
    json = response.match(/{.*}/m)
    is_company = JSON.parse(json.to_s)["is_company_website"] rescue nil
    search_engine_result.update!(is_company: is_company)
  end

  private
  def user_prompt(search_engine_result)
    <<-TXT
      Task : Analyse the content of search engine result and find if the provided search engine results content leads to the website of a company in the #{search_engine_result.query} business.
      Background : We're building a directory of software companies and want to find all the comanies in the #{search_engine_result.query} business.
      We've performed a search for #{search_engine_result.query} on duckduckgo and found the following search engine result: #{analysis_input(search_engine_result)}
      Analyze the search engine result and figure out if it is the website of a company in the #{search_engine_result.query} business.
      If it is the website of a company in the #{search_engine_result.query} business then answer yes to the question: Is it the website of a company in the #{search_engine_result.query} business ?
      We don't want to include comparison websites, review websites, software download websites, software directories, or blogs in our directory.
      Is this search engine result about the website of a company in the #{search_engine_result.query} business ?
      if title looks like Best Mobile Event Apps Software 2025, then it is the website of a software directory and not a company in the #{search_engine_result.query} business.
      if title looks like The 15 Best Mobile Event Apps (and How to Choose One) then it is a software review website and not the website of a company in the #{search_engine_result.query} business.
      Your response must be a json object with the following structure:
      {
        is_company_website: "Your answer here to the question : is the search engine result about the website of a company in the #{search_engine_result.query} business ?",
      }
    TXT
  end

  def response_schema(search_engine_result)
    {
      "strict": true,
      "name": "is_company_website",
      "description": "Checks if a website is a company website",
      "schema": {
        "type": "object",
        "properties": {
          "is_company_website": {
            "type": "boolean",
            "description": "Your answer here to the question : is the provided search engine results leading to the website of a company in the #{search_engine_result.query} business ? Search engine result to analyze: #{analysis_input(search_engine_result)}"
          }
        },
        "additionalProperties": false,
        "required": [ "is_company_webiste" ]
      }
    }
  end

  def analysis_input(search_engine_result)
    <<-TXT
      site_name: #{search_engine_result.site_name},
      title: #{search_engine_result.title},
      url: #{search_engine_result.url},
      description: #{search_engine_result.description}
    TXT
  end
end
