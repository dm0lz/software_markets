class SearchEngineResultAiAnalyzerJob < ApplicationJob
  queue_as :default

  def perform(search_engine_result)
    analysis_input = "site_name: #{search_engine_result.site_name}, title: #{search_engine_result.title}, url: #{search_engine_result.url}, description: #{search_engine_result.description}"
    response = OpenaiService.new.call(user_prompt(search_engine_result, analysis_input))
    logger.info response
    json = response.match(/{.*}/m)
    is_company = JSON.parse(json.to_s)["is_company_website"] rescue nil
    search_engine_result.update!(is_company: is_company)
  end

  private
  def user_prompt(search_engine_result, analysis_input)
    <<-TXT
      We're building a directory of software companies and want to find all the comanies in the #{search_engine_result.query} business.
      We've performed a search for #{search_engine_result.query} on duckduckgo and found the following search engine result: #{analysis_input}
      Analyze the search engine result and figure out if it is the website of a company in the #{search_engine_result.query} business.
      We don't want to include comparison websites, review websites, software download websites, software directories, or blogs in our directory.
      Is this search engine result the website of a company in the #{search_engine_result.query} business ?
      if title looks like Best Mobile Event Apps Software 2025, then it is a software directory
      if title looks like The 15 Best Mobile Event Apps (and How to Choose One) then it is a software review website
      Your response must be a json object with the following structure:
      {
        is_company_website: "Your answer here (must be true or false)",
      }
    TXT
  end
end
