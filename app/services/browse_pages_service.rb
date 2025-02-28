# Use double quotes only in the JS code
class BrowsePagesService < BaseService
  def initialize(urls, options)
    @urls = urls
    @options = options
  end

  def call(script)
    puts js_code
    output, error, status = Open3.capture3(%Q(node -e '#{js_code.strip}'))
    if status.success?
      JSON.parse(output)
    else
      logger.error "Error: #{error}"
    end
  end

  private
  def js_code
    <<-JS
      const { firefox } = require("playwright");
      (async () => {
        const browser = await firefox.launch(#{@options});
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
            } catch(error) {
              return null;
            }
          })
        );
        console.log(JSON.stringify(results));
        await browser.close();
      })();
    JS
  end
end
