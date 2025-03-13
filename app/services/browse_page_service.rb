# Use double quotes only in the JS code
class BrowsePageService < BaseService
  def initialize(url, script, options = "{}")
    @url = url
    @script = script
    @options = options
  end

  def call
    ExecuteNodeScriptService.new.call(js_code)
  end

  private
  def js_code
    <<-JS
      const { firefox } = require("playwright");
      (async () => {
        const browser = await firefox.launch(#{@options});
        const page = await browser.newPage();
        await page.goto("#{@url}");
        const data = await page.evaluate(() => {
          #{@script}
        });
        console.log(JSON.stringify(data));
        await browser.close();
      })();
    JS
  end
end
