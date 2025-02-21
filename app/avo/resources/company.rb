class Avo::Resources::Company < Avo::BaseResource
  # self.includes = []
  # self.attachments = []
  self.search = {
    query: -> { query.ransack(name_cont: params[:q], domains_name_cont: params[:q], m: "or").result(distinct: false) }
  }

  def fields
    field :id, as: :id
    field :name, as: :text
    field :market_id, as: :number
    field :domains, as: :has_many
    field :company_markets, as: :has_many
    field :markets, as: :has_many, through: :company_markets
    field :software_applications, as: :has_many, through: :domains
  end
end
