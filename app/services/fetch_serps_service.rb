class FetchSerpsService < BaseService
  def initialize(pages_number = 10, options = "{}")
    @pages_number = pages_number
    @options = options
  end
  def call(queries)
    BrowsePagesService.new(urls(queries), @options).call(js_code)
  end

  def urls(queries)
    queries.map do |query|
      "https://duckduckgo.com/?t=h_&q=#{query.gsub("'", "")}"
    end
  end

  private
  def js_code
    <<-JS
      const loadMorePromises = [...Array(#{@pages_number})].map(async (_, i) => {
        await new Promise(resolve => setTimeout(resolve, i * 500));
        const moreResultsButton = document.querySelector("#more-results");
        if (!moreResultsButton) return;
        moreResultsButton.click();
        await new Promise(resolve => setTimeout(resolve, 200));
        document.documentElement.scroll({ top: document.documentElement.scrollHeight });
      });
      return Promise.all(loadMorePromises).then(() => {
        return {
          serp_url: document.location.href,
          search_results: [...document.querySelectorAll("ol > li > article")].map((article, index) => {
            return {
              site_name: article.querySelector("article > div:nth-child(2)").querySelector("p").textContent,
              url: article.querySelector("article > div:nth-child(3)").querySelector("a").getAttribute("href"),
              title: article.querySelector("article > div:nth-child(3)").querySelector("h2").textContent,
              description: article.querySelector("article > div:nth-child(4)").querySelector("div").textContent,
              position: index + 1
            }
          })
        }
      });
    JS
  end
end
