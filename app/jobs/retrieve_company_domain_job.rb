# Company.joins(:domains).where.not(domains: {name: nil}).count
# Company.joins(:domains).where(domains: {name: nil}).each{|l| RetrieveCompanyDomainJob.perform_later(l)}
class RetrieveCompanyDomainJob < ApplicationJob
  queue_as :default

  def perform(company)
    company_name = company.name.downcase.gsub("'", "")
    url = "https://duckduckgo.com/?t=h_&q=#{company_name}+Official+Website&ia=web"
    return unless results = Fetcher::PageEvaluatorService.new(url).call(js_code(company_name))
    puts results["count"]
    company.domains.find_or_create_by!(name: PublicSuffix.domain(results["domain"]))
    logger.info "#{results["domain"]}"
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
        const domainMap = [...document.querySelectorAll("h2 > a")]
          .filter(item => !item.getAttribute("href").includes("ad_domain="))
          .map(item => item.getAttribute("href"))
          .reduce((acc, url) => {
            if (!url.startsWith("/")) {
              (acc[new URL(url).hostname] ||= []).push(url);
            }
            return acc;
          }, {});
        const entries = Object.entries(domainMap);
        if (entries.length === 0) return null;
        return entries.reduce((max, entry) => entry[1].length > max[1].length ? entry : max, entries[0])[0];
      };
      const matchingCompanyName = () => {
        const domain = [...document.querySelectorAll("ol > li > article")]
          .filter(item => !item.querySelector("article > div:nth-child(2) > div > div > a")?.getAttribute("href").includes("play.google.com"))
          ?.find(item => item.querySelector("article > div:nth-child(2) > div > div > p")?.textContent.toLowerCase() === "#{company_name}")
          ?.querySelector("article > div:nth-child(3) > h2 > a")
          ?.getAttribute("href");
        return domain ? new URL(domain).hostname : null;
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
