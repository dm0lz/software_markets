# Use double quotes only in the JS code
class PythonScriptExecutorService < BaseService
  def call(script)
    output, error, status = Open3.capture3(%Q(uv run python -c '#{script.gsub(/^ {6}|'/, "")}'))
    if status.success?
      JSON.parse(output)
    else
      logger.error "Error: #{error}"
    end
  end
end
