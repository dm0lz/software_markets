class Avo::Resources::CompanyMarket < Avo::BaseResource
  # self.includes = []
  # self.attachments = []
  # self.search = {
  #   query: -> { query.ransack(id_eq: params[:q], m: "or").result(distinct: false) }
  # }
  
  def fields
    field :id, as: :id
    field :company_id, as: :number
    field :market_id, as: :number
    field :company, as: :belongs_to
    field :market, as: :belongs_to
  end
end


