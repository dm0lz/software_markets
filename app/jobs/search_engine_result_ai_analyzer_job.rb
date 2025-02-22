class SearchEngineResultAiAnalyzerJob < ApplicationJob
  queue_as :default

  def perform(search_engine_result)
    analysis_input = "site_name: #{search_engine_result.site_name}, title: #{search_engine_result.title}, url: #{search_engine_result.url}, description: #{search_engine_result.description}"
    response = OpenaiService.new.call(user_prompt(search_engine_result) + analysis_input)
    puts response
    json = response.match(/{.*}/m)
    is_company = JSON.parse(json.to_s)["is_company_website"] rescue nil
    search_engine_result.update!(is_company: is_company)
  end

  private
  def user_prompt(search_engine_result)
    <<-TXT
      Is this search engine result the website of a company in the #{search_engine_result.query} business.
      Is it a comparison website ?
      Is it a review website ?
      Is it a software download website ?
      Is it a software directory ?
      Is it a software review website ?
      Is it a software comparison website ?
      Is it a Blog ?
      if title looks like Best Mobile Event Apps Software 2025, then it is a software directory
      if title looks like The 15 Best Mobile Event Apps (and How to Choose One) then it is a software review website
      Your response must be a json object with the following structure:
      {
        is_company_website: "Your answer here (must be true or false)",
      }
    TXT
  end
end
