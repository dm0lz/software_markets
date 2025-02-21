class Avo::Resources::Provider < Avo::BaseResource
  # self.includes = []
  # self.attachments = []
  # self.search = {
  #   query: -> { query.ransack(id_eq: params[:q], m: "or").result(distinct: false) }
  # }
  
  def fields
    field :id, as: :id
    field :name, as: :text
    field :domain, as: :text
    field :market_providers, as: :has_many
    field :markets, as: :has_many, through: :market_providers
  end
end


