# Use double quotes only in the JS code
class BrowsePageService < BaseService
  def initialize(url, options = "{}")
    @url = url
    @options = options
  end

  def call(script)
    ExecuteNodeScriptService.new.call(js_code(script))
  end

  private
  def js_code(script)
    <<-JS
      const { firefox } = require("playwright");
      (async () => {
        const browser = await firefox.launch(#{@options});
        const page = await browser.newPage();
        await page.goto("#{@url}");
        const data = await page.evaluate(() => {
          #{script}
        });
        console.log(JSON.stringify(data));
        await browser.close();
      })();
    JS
  end
end
