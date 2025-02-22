class RetrieveCompanyDomainJob < ApplicationJob
  queue_as :default

  def perform(company)
    company_name = company.name.downcase.gsub("'", "")
    url = "https://duckduckgo.com/?t=h_&q=#{company_name}+Official+Website+site%3A.com&ia=web"
    output, error, status = BrowsePageService.new(url, "{}").call(js_code(company_name))
    if status.success?
      results = JSON.parse(output)
      puts results["count"]
      company.domains.update_all(name: results["domain"])
      logger.info "#{results["domain"]}"
    else
      logger.error "Error: #{error}"
    end
  end

  private
  def js_code(company_name)
    <<-JS
      const loadMorePromises = [...Array(10)].map(async (_, i) => {
        await new Promise(resolve => setTimeout(resolve, i * 500));
        const moreResultsButton = document.querySelector("#more-results");
        if (!moreResultsButton) return;
        moreResultsButton.click();
        await new Promise(resolve => setTimeout(resolve, 200));
        document.documentElement.scroll({ top: document.documentElement.scrollHeight });
      });
      const getRecurringDomain = () => {
        return Object.entries(
          [...document.querySelectorAll("h2 > a")]
            .filter(item => !item.getAttribute("href").includes("ad_domain="))
            .map(item => item.getAttribute("href"))
            .reduce((acc, url) => {
              (acc[new URL(url).hostname] ||= []).push(url);
              return acc;
            }, {})
        ).reduce((max, entry) => entry[1].length > max[1].length ? entry : max)[0];
      };
      const matchingCompanyName = () => {
        return [...document.querySelectorAll("ol > li > article")]
          .filter(item => !item.querySelector("article > div:nth-child(2) > div > div > a").getAttribute("href").includes("play.google.com"))
          ?.find(item => item.querySelector("article > div:nth-child(2) > div > div > p")?.textContent.toLowerCase() === "#{company_name}")
          ?.querySelector("article > div:nth-child(3) > h2 > a")
          ?.getAttribute("href");
      };
      return Promise.all(loadMorePromises).then(() => {
        return {
          domain: matchingCompanyName() || getRecurringDomain(),
          count: document.querySelectorAll("h2 > a").length
        };
      });
    JS
  end
end
