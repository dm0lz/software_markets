require "test_helper"

class ExtractDomainFeatureJobTest < ActiveJob::TestCase
  def setup
    @domain = create(:domain, name: "skuuudle.com")
    @query = create(:feature_extraction_query)
  end

  test "should scrap domain" do
    ScrapDomainJob.perform_later(@domain)
    @domain.generate_extracted_content(@query)
    assert_not_nil @domain.extracted_content[FeatureExtractionQuery.first.search_field]
  end
end
