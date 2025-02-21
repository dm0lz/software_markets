class Avo::Resources::MarketProvider < Avo::BaseResource
  # self.includes = []
  # self.attachments = []
  # self.search = {
  #   query: -> { query.ransack(id_eq: params[:q], m: "or").result(distinct: false) }
  # }
  
  def fields
    field :id, as: :id
    field :market_id, as: :number
    field :provider_id, as: :number
    field :market_name, as: :text
    field :market_url, as: :text
    field :description, as: :textarea
    field :competitors_count, as: :number
    field :market, as: :belongs_to
    field :provider, as: :belongs_to
  end
end


