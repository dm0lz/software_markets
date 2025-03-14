# Use double quotes only in the JS code
class BrowsePageStealthService < BaseService
  def initialize(url, options = "{}")
    @url = url
    @options = options
  end

  def call(script)
    js_code = <<-JS
      const { chromium } = require("playwright-extra");
      const stealth = require("puppeteer-extra-plugin-stealth")();
      chromium.use(stealth);
      (async () => {
        const browser = await chromium.launch(#{@options});
        const page = await browser.newPage();
        await page.goto("#{@url}");
        const data = await page.evaluate(() => {
          #{script}
        });
        console.log(JSON.stringify(data));
        await browser.close();
      })();
    JS

    ExecuteNodeScriptService.new.call(js_code)
  end
end
