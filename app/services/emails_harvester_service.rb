class EmailsHarvesterService
  def call(domain)
    serp = FetchSerpService.new.call("inbody%3A*%40#{domain.name}")
    serp["search_results"].map do |search_engine_result|
      page = FetchWebPageService.new.call(search_engine_result["url"])
      page["content"].scan(/\b[A-Za-z0-9._%+-]+@#{Regexp.escape(domain.name)}\b/i)
    end.flatten.compact.uniq
  end
end
