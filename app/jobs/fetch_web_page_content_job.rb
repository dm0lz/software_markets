class FetchWebPageContentJob < ApplicationJob
  queue_as :default

  def perform(url)
    return unless results = FetchWebPageService.new.call(url)
    domain = Domain.find_by(name: URI.parse(url).host)
    web_page = domain.web_pages.find_or_create_by!(url: url)
    web_page.update!(content: results["content"])
  end
end
