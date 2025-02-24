class DomainAiAnalyzerJob < ApplicationJob
  queue_as :default

  def perform(domain)
    pages_content = domain.web_pages.pluck(:content).join(" ").truncate(15000)
    response = OpenaiService.new.call(user_prompt + pages_content)
    logger.info response
    json_content = JSON.parse(response.match(/{.*}/m).to_s) rescue nil
    domain.update!(extracted_content: json_content) if json_content
  end

  private
  def user_prompt
    <<-PROMPT
      Key task : Analyze the content of the web pages and extract the company information.
      Expected Output : Extracted company information in a structured format (JSON).
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
      If you need to provide any next steps or action items, you can do so in the response.
      If you need to provide any follow-up questions or tasks, you can do so in the response.
      If you need more information, you can ask for it in the response.
      !!! Your response must be a json object with the following structure:
      {
        summary: "Your summary here",
        company_focus: "The company's main focus",
        key_points: ["Key point 1", "Key point 2", "Key point 3"],
        market: "The company's market here",
        key_features: ["Feature 1", "Feature 2", "Feature 3"],
        uniq_sell_points: ["USP 1", "USP 2", "USP 3"],
        company_name: "Company Name",
        website_url: "Website URL",
        year_founded: "Year Founded",
        company_size: "Company Size",
        headquarters_location: "Headquarters Location",
        legal_structure: "Legal Structure",
        contact_information: "Contact Information",
        company_description: "Company Description",
        industry: "Industry & Sub-Industry",
        market_segmentation: "Market Segmentation",
        geographical_market: "Geographical Market",
        key_competitors: "Key Competitors",
        core_products: "Core Products or Services",
        unique_selling_proposition: "Unique Selling Proposition",
        product_pricing: "Product Pricing & Pricing Model",
        product_features: "Product Features & Differentiators",
        customer_pain_points: "Customer Pain Points Addressed",
        revenue_estimates: "Revenue Estimates",
        funding_rounds: "Funding Rounds & Investors",
        profitability_growth_trends: "Profitability & Growth Trends",
        pricing_strategy: "Pricing Strategy",
        customer_acquisition_cost: "Customer Acquisition Cost",
        lifetime_value: "Lifetime Value of Customers",
        target_audience: "Target Audience & Customer Profile",
        customer_reviews: "Customer Reviews & Ratings",
        brand_reputation: "Brand Reputation & Social Proof",
        customer_support: "Customer Support & Satisfaction",
        customer_retention: "Customer Retention & Churn Rate",
        primary_sales_channels: "Primary Sales Channels",
        marketing_channels: "Marketing Channels Used",
        social_media_presence: "Social Media Presence & Engagement",
        content_strategy: "Content Strategy",
        partnerships: "Partnerships & Affiliations",
        tech_stack: "Tech Stack Used",
        ai_automation: "Use of AI & Automation",
        security_compliance: "Security & Compliance Measures",
        apis_integrations: "APIs & Integrations",
        strengths_opportunities: "Strengths & Opportunities",
        weaknesses_threats: "Weaknesses & Threats",
        barriers_to_entry: "Barriers to Entry for Competitors",
        patents: "Patents, Proprietary Tech, or IP Protection",
        job_openings: "Job Openings & Hiring Patterns",
        company_culture: "Company Culture & Employee Satisfaction",
        remote_work_policy: "Remote vs. On-Site Work Policy",
        regulations: "Regulations Affecting the Business",
        compliance: "GDPR, CCPA, HIPAA Compliance",
        lawsuits: "Lawsuits or Legal Challenges"
      }
    PROMPT
  end
end
