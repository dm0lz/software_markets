# Use double quotes only in the JS code
class NodeScriptExecutorService < BaseService
  def call(script)
    output, error, status = Open3.capture3(%Q(node -e '#{script.gsub("'", "").strip}'))
    if status.success?
      JSON.parse(output)
    else
      logger.error "Error: #{error}"
    end
  end
end
