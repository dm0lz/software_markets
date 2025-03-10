# Use double quotes only in the JS code
class BrowsePageService < BaseService
  def initialize(url, options)
    @url = url
    @options = options
  end

  def call(script)
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
