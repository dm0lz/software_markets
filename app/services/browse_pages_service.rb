# Use double quotes only in the JS code
class BrowsePagesService
  def initialize(urls, options)
    @urls = urls
    @options = options
  end

  def call(script)
    js_code = <<-JS
      const { firefox } = require("playwright");
      (async () => {
        const browser = await firefox.launch(#{@options});
        const results = [];
        await Promise.all(
          #{@urls}.map(async(url) => {
            const page = await browser.newPage();
            await page.goto(url);
            const data = await page.evaluate(() => {
              #{script}
            });
            results.push(data);
          })
        );
        console.log(JSON.stringify(results));
        await browser.close();
      })();
    JS
    puts js_code

    Open3.capture3(%Q(node -e '#{js_code.strip}'))
  end
end
