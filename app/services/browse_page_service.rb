# Use double quotes only in the JS code
class BrowsePageService
  def initialize(url, options)
    @url = url
    @options = options
  end

  def call(script)
    js_code = <<-JS
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

    Open3.capture3(%Q(node -e '#{js_code.strip}'))
  end
end
