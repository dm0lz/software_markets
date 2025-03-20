class GoogleSerpFetcherService < BaseService
  def initialize(pages_number: 10, options: "{}")
    @pages_number = pages_number
    @options = options
  end

  def call(query)
    serps = NodeScriptExecutorService.new.call(js_code(query))
    serps.map { |serp| serp["search_results"] }.flatten
  end

  private
  def js_code(query)
    <<-JS
      const puppeteer = require("puppeteer-extra");
      const RecaptchaPlugin = require("puppeteer-extra-plugin-recaptcha");
      puppeteer.use(
        RecaptchaPlugin({
          provider: {
            id: "2captcha",
            token: "#{Rails.application.credentials.two_captcha_token}",
          },
          visualFeedback: true,
        })
      );
      const StealthPlugin = require("puppeteer-extra-plugin-stealth");
      puppeteer.use(StealthPlugin());
      const run_script = (positionOffset) => {
        return {
          next: document.querySelector("#pnnext")?.getAttribute("href"),
          serp_url: document.location.href,
          search_results: [
            ...document.querySelectorAll("#search > div > div > div"),
          ].map((article, index) => ({
            site_name:
              article
                .querySelector(
                  "div > div > div > div > div > div > div > div > div > div > div > div > div > div > div > div > div > div > div"
                )
                ?.textContent?.trim() || "N/A",
            url:
              article
                .querySelector(
                  "div > div > div > div > div > div > div > div > div > div > div > div > div > div > span > a"
                )
                ?.getAttribute("href") || "N/A",
            title:
              article
                .querySelector(
                  "div > div > div > div > div > div > div > div > div > div > div > div > div > div > span > a > h3"
                )
                ?.textContent?.trim() || "N/A",
            description:
              article
                .querySelectorAll(
                  "div > div > div > div > div > div > div > div > div > div > div"
                )
                [
                  article.querySelectorAll(
                    "div > div > div > div > div > div > div > div > div > div > div"
                  ).length - 1
                ]?.textContent?.trim() || "N/A",
            position: positionOffset + index + 1,
          })),
        };
      };
      (async () => {
        const browser = await puppeteer.launch(#{@options});
        const page = await browser.newPage();
        await page.goto("https://www.google.com/");
        await page.click("#L2AGLb");
        await page.type("textarea", "#{query}");
        await page.keyboard.press("Enter");
        await page.waitForSelector("iframe");
        const { captchas, filtered, solutions, solved, error } =
          await page.solveRecaptchas();
        await page.waitForNavigation();
        const results = [];
        let positionOffset = 0;
        while (true) {
          const data = await page.evaluate(run_script, positionOffset);
          results.push(data);
          positionOffset += data.search_results.length;
          if (!data.next || positionOffset / 10 >= #{@pages_number}) {
            break;
          }
          await page.goto("https://www.google.com" + data.next);
        }
        console.log(JSON.stringify(results));
        await browser.close();
      })();
    JS
  end
end
