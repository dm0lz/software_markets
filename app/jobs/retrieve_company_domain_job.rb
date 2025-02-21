class RetrieveCompanyDomainJob < ApplicationJob
  queue_as :default

  def perform(company)
    url = "https://duckduckgo.com/?t=h_&q=#{company.name.gsub("'", "")}+Official+Website&ia=web"
    output, error, status = BrowsePageService.new(url, "{headless: false, slowMo: 4000}").call(js_code)
    if status.success?
      results = JSON.parse(output)
      company.domains.update_all(name: results["domain"])
      logger.info "#{results["domain"]} "
    else
      logger.error "Error: #{error}"
    end
  end

  private
  def js_code
    <<-JS
      const loadMorePromises = [...Array(4)].map(async (_, i) => {
        await new Promise(resolve => setTimeout(resolve, i * 500));
        document.querySelector("#more-results").click();
        await new Promise(resolve => setTimeout(resolve, 200));
        document.documentElement.scroll({ top: document.documentElement.scrollHeight });
      });
      return Promise.all(loadMorePromises).then(() => {
        return {
          domain: Object.entries(
            [...document.querySelectorAll("h2 > a")]
              .filter(item => !item.getAttribute("href").includes("ad_domain="))
              .map(item => item.getAttribute("href"))
              .reduce((acc, url) => {
                (acc[new URL(url).hostname] ||= []).push(url);
                return acc;
              }, {})
          ).reduce((max, entry) => entry[1].length > max[1].length ? entry : max)[0]
        };
      });
    JS
  end
end
