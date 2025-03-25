class ApiSession < ApplicationRecord
  belongs_to :user
  validates :endpoint, presence: true
  after_create :set_credit

  private
  def set_credit
    user.update!(api_credit: user.api_credit - api_endpoint_credit[endpoint])
  end

  def api_endpoint_credit
    {
      "api/v1/scrap_web_page" => 5,
      "api/v1/scrap_web_pages" => 20,
      "api/v1/scrap_domain" => 50,
      "api/v1/company_domain" => 5,
      "api/v1/domain_emails" => 10,
      "api/v1/analyze_web_page" => 25,
      "api/v1/analyze_serp" => 25,
      "api/v1/hf_inference" => 25,
      "api/v1/hf_models" => 1,
      "api/v1/serp" => 30
    }
  end
end
