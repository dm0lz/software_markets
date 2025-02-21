class Avo::Resources::Market < Avo::BaseResource
  # self.includes = []
  # self.attachments = []
  self.search = {
    query: -> { query.ransack(name_cont: params[:q], m: "or").result(distinct: false) }
  }

  def fields
    field :id, as: :id
    field :name, as: :text
    field :market_providers, as: :has_many
    field :providers, as: :has_many, through: :market_providers
    field :company_markets, as: :has_many
    field :companies, as: :has_many, through: :company_markets
  end
end
