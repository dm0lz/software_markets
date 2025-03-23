# Use double quotes only in the JS code
class Scraper::PagesEvaluatorService < BaseService
  def initialize(urls, options = "{}")
    @urls = urls
    @options = options
  end

  def call(script)
    puts js_code(script)
    RuntimeExecutor::NodeService.new.call(js_code(script))
  end

  private
  # def js_code(script)
  #   <<-JS
  #     const { chromium } = require("playwright-extra");
  #     const stealth = require("puppeteer-extra-plugin-stealth")();
  #     chromium.use(stealth);
  #     (async () => {
  #       const browser = await chromium.launch(#{@options});
  #       const results = [];
  #       for (const url of #{@urls}) {
  #         try {
  #           const page = await browser.newPage();
  #           await page.goto(url);
  #           const data = await page.evaluate(() => {
  #             #{script}
  #           });
  #           results.push(data);
  #           await page.close();
  #         } catch (error) {}
  #       }
  #       console.log(JSON.stringify(results));
  #       await browser.close();
  #     })();
  #   JS
  # end

  def js_code(script)
    <<-JS
      const { chromium } = require("playwright-extra");
      const stealth = require("puppeteer-extra-plugin-stealth")();
      chromium.use(stealth);
      (async () => {
        const browser = await chromium.launch(#{@options});
        const results = [];
        await Promise.all(
          #{@urls}.map(async(url) => {
            try {
              const page = await browser.newPage();
              await page.goto(url);
              const data = await page.evaluate(() => {
                #{script}
              });
              results.push(data);
              await page.close();
            } catch (error) {}
          })
        );
        console.log(JSON.stringify(results));
        await browser.close();
      })();
    JS
  end
end
