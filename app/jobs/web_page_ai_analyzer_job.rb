class WebPageAiAnalyzerJob < ApplicationJob
  queue_as :default

  def perform(web_page)
    page_content = web_page.content[0, web_page.content.length / 4]
    response = OpenaiService.new.call(user_prompt + page_content)
    web_page.update!(extracted_content: response)
  end

  private
  def user_prompt
    <<-TXT
      Provide a summary of the company's web page content.
      Include the main company focus and key points.
      Include the main company market.
      Include the features of the company's product.
      Include the company's unique selling points.
      Do not talk about cookies.
      Your response must be a json object with the following structure:
      {
        summary: "Your summary here",
        market: "The company's market here",
        key_features: ["Feature 1", "Feature 2", "Feature 3"],
        uniq_sell_points: ["USP 1", "USP 2", "USP 3"]
      }
    TXT
  end
end
