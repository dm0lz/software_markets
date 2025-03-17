class SummarizeWebPageJob < ApplicationJob
  queue_as :default
  queue_with_priority 2

  def perform(web_page)
    response = TextSummarizerService.new.call(web_page.content)
    web_page.update!(summary: response["summary_text"])
  end
end
