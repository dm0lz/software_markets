class AnalyzeWebPageJob < ApplicationJob
  queue_as :default

  def perform(web_page)
    response = OpenaiService.new.call(user_prompt + web_page.content, response_schema)
    logger.info response
    web_page.update!(extracted_content: response)
  end

  private
  def user_prompt
    <<-PROMPT
      Key task : Analyze the content of the page and extract the company information.
      Provide a summary of the company's activity.
      Include the following information:

      1. General Company Information
      -	Company Name
      -	Website URL
      -	Year Founded
      -	Company Size (Number of Employees)
      -	Headquarters Location
      -	Legal Structure (LLC, Corporation, Sole Proprietorship, etc.)
      -	Contact Information (Email, Phone, Social Media)
      -	Company Description
      - main company focus and key points.
      - main company market.
      - features of the company's product.
      - company's unique selling points.

      2. Industry & Market Position
      -	Industry & Sub-Industry (e.g., SaaS, FinTech, Healthcare)
      -	Market Segmentation (B2B, B2C, Enterprise, SMBs)
      -	Geographical Market (Local, National, Global)
      -	Key Competitors

      3. Product & Service Offerings
      -	Core Products or Services
      -	Unique Selling Proposition (USP)
      -	Product Pricing & Pricing Model (Subscription, One-time, Freemium, etc.)
      -	Product Features & Differentiators
      -	Customer Pain Points Addressed

      4. Financial & Business Performance (if available)
      -	Revenue Estimates
      -	Funding Rounds & Investors
      -	Profitability & Growth Trends
      -	Pricing Strategy
      -	Customer Acquisition Cost (CAC)
      -	Lifetime Value (LTV) of Customers

      5. Customer & Market Insights
      - Target Audience & Customer Profile (Demographics, Psychographics)
      - Customer Reviews & Ratings (Trustpilot, G2, Capterra, etc.)
      - Brand Reputation & Social Proof
      - Customer Support & Satisfaction (Response time, Support channels)
      - Customer Retention & Churn Rate

      6. Marketing & Sales Strategies
      - Primary Sales Channels (Direct, Online, Resellers, etc.)
      -	Marketing Channels Used (SEO, Ads, Social Media, Email, etc.)
      -	Social Media Presence & Engagement
      -	Content Strategy (Blogs, Whitepapers, Webinars, etc.)
      -	Partnerships & Affiliations

      7. Technology & Infrastructure
      - Tech Stack Used (Programming Languages, Frameworks, Hosting)
      -	Use of AI & Automation
      -	Security & Compliance Measures
      -	APIs & Integrations

      8. Competitive Advantage & Weaknesses
      -	Strengths & Opportunities
      -	Weaknesses & Threats (SWOT Analysis)
      -	Barriers to Entry for Competitors
      -	Patents, Proprietary Tech, or IP Protection

      9. Hiring & Workforce Trends
      -	Job Openings & Hiring Patterns
      -	Company Culture & Employee Satisfaction (Glassdoor Reviews, LinkedIn Insights)
      -	Remote vs. On-Site Work Policy

      10. Legal & Compliance Factors
      -	Regulations Affecting the Business
      -	GDPR, CCPA, HIPAA Compliance (If applicable)
      -	Lawsuits or Legal Challenges

      If you don't have access to specific data, you can mention that it's not available.
    PROMPT
  end

  def response_schema
    {
      "strict": true,
      "name": "is_company_website",
      "description": "Checks if a website is a company website",
      "schema": {
        "type": "object",
        "properties": {
          "summary": { "type": "string", "description": "Your summary" },
          "company_focus": { "type": "string", "description": "The company's main focus" },
          "key_points": { "type": "array", "items": { "type": "string" }, "description": "Key points about the company" },
          "market": { "type": "string", "description": "The company's market" },
          "key_features": { "type": "array", "items": { "type": "string" }, "description": "Key features of the company's product/service" },
          "uniq_sell_points": { "type": "array", "items": { "type": "string" }, "description": "Unique selling points" },
          "company_name": { "type": "string", "description": "Company name" },
          "website_url": { "type": "string", "description": "Company website URL" },
          "year_founded": { "type": "string", "description": "Year the company was founded" },
          "company_size": { "type": "string", "description": "Size of the company" },
          "headquarters_location": { "type": "string", "description": "Location of headquarters" },
          "legal_structure": { "type": "string", "description": "Legal structure of the company" },
          "contact_information": { "type": "string", "description": "Contact information" },
          "company_description": { "type": "string", "description": "Detailed description of the company" },
          "industry": { "type": "string", "description": "Industry & sub-industry" },
          "market_segmentation": { "type": "string", "description": "Market segmentation" },
          "geographical_market": { "type": "string", "description": "Geographical market served" },
          "key_competitors": { "type": "string", "description": "Key competitors" },
          "core_products": { "type": "string", "description": "Core products or services" },
          "unique_selling_proposition": { "type": "string", "description": "Unique selling proposition" },
          "product_pricing": { "type": "string", "description": "Product pricing & pricing model" },
          "product_features": { "type": "string", "description": "Product features & differentiators" },
          "customer_pain_points": { "type": "string", "description": "Customer pain points addressed" },
          "revenue_estimates": { "type": "string", "description": "Revenue estimates" },
          "funding_rounds": { "type": "string", "description": "Funding rounds & investors" },
          "profitability_growth_trends": { "type": "string", "description": "Profitability & growth trends" },
          "pricing_strategy": { "type": "string", "description": "Pricing strategy" },
          "customer_acquisition_cost": { "type": "string", "description": "Customer acquisition cost" },
          "lifetime_value": { "type": "string", "description": "Lifetime value of customers" },
          "target_audience": { "type": "string", "description": "Target audience & customer profile" },
          "customer_reviews": { "type": "string", "description": "Customer reviews & ratings" },
          "brand_reputation": { "type": "string", "description": "Brand reputation & social proof" },
          "customer_support": { "type": "string", "description": "Customer support & satisfaction" },
          "customer_retention": { "type": "string", "description": "Customer retention & churn rate" },
          "primary_sales_channels": { "type": "string", "description": "Primary sales channels" },
          "marketing_channels": { "type": "string", "description": "Marketing channels used" },
          "social_media_presence": { "type": "string", "description": "Social media presence & engagement" },
          "content_strategy": { "type": "string", "description": "Content strategy" },
          "partnerships": { "type": "string", "description": "Partnerships & affiliations" },
          "tech_stack": { "type": "string", "description": "Tech stack used" },
          "ai_automation": { "type": "string", "description": "Use of AI & automation" },
          "security_compliance": { "type": "string", "description": "Security & compliance measures" },
          "apis_integrations": { "type": "string", "description": "APIs & integrations" },
          "strengths_opportunities": { "type": "string", "description": "Strengths & opportunities" },
          "weaknesses_threats": { "type": "string", "description": "Weaknesses & threats" },
          "barriers_to_entry": { "type": "string", "description": "Barriers to entry for competitors" },
          "patents": { "type": "string", "description": "Patents, proprietary tech, or IP protection" },
          "job_openings": { "type": "string", "description": "Job openings & hiring patterns" },
          "company_culture": { "type": "string", "description": "Company culture & employee satisfaction" },
          "remote_work_policy": { "type": "string", "description": "Remote vs. on-site work policy" },
          "regulations": { "type": "string", "description": "Regulations affecting the business" },
          "compliance": { "type": "string", "description": "GDPR, CCPA, HIPAA compliance" },
          "lawsuits": { "type": "string", "description": "Lawsuits or legal challenges" }
        },
        "additionalProperties": false,
        "required": [
          "summary",
          "company_focus",
          "key_points",
          "market",
          "key_features",
          "uniq_sell_points",
          "company_name",
          "website_url",
          "year_founded",
          "company_size",
          "headquarters_location",
          "legal_structure",
          "contact_information",
          "company_description",
          "industry",
          "market_segmentation",
          "geographical_market",
          "key_competitors",
          "core_products",
          "unique_selling_proposition",
          "product_pricing",
          "product_features",
          "customer_pain_points",
          "revenue_estimates",
          "funding_rounds",
          "profitability_growth_trends",
          "pricing_strategy",
          "customer_acquisition_cost",
          "lifetime_value",
          "target_audience",
          "customer_reviews",
          "brand_reputation",
          "customer_support",
          "customer_retention",
          "primary_sales_channels",
          "marketing_channels",
          "social_media_presence",
          "content_strategy",
          "partnerships",
          "tech_stack",
          "ai_automation",
          "security_compliance",
          "apis_integrations",
          "strengths_opportunities",
          "weaknesses_threats",
          "barriers_to_entry",
          "patents",
          "job_openings",
          "company_culture",
          "remote_work_policy",
          "regulations",
          "compliance",
          "lawsuits"
        ]
      }
    }
  end
end
