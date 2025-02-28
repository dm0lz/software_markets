# Use double quotes only in the JS code
class BrowsePagesService < BaseService
  def initialize(urls, options)
    @urls = urls
    @options = options
  end

  def call(script)
    puts js_code(script)
    output, error, status = Open3.capture3(%Q(node -e '#{js_code(script).strip}'))
    if status.success?
      JSON.parse(output)
    else
      logger.error "Error: #{error}"
    end
  end

  private
  def js_code(script)
    <<-JS
      const { firefox } = require("playwright");
      (async () => {
        const browser = await firefox.launch(#{@options});
        const results = [];
        for (const url of #{@urls}) {
          try {
            const page = await browser.newPage();
            await page.goto(url, { timeout: 10000, waitUntil: "domcontentloaded" });
            const data = await Promise.race([
              page.evaluate(() => {
                #{script}
              }),
              new Promise((_, reject) =>
                setTimeout(() => reject(new Error("Evaluate Timeout")), 10000)
              )
            ]);
            results.push(data);
            await page.close();
          } catch (error) {
            console.error(`Error scraping ${url}:`, error);
          }
        }
        console.log(JSON.stringify(results));
        await browser.close();
      })();
    JS
  end
end
