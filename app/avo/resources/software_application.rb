class Avo::Resources::SoftwareApplication < Avo::BaseResource
  # self.includes = []
  # self.attachments = []
  # self.search = {
  #   query: -> { query.ransack(id_eq: params[:q], m: "or").result(distinct: false) }
  # }
  
  def fields
    field :id, as: :id
    field :name, as: :text
    field :domain_id, as: :number
    field :provider_url, as: :text
    field :description, as: :textarea
    field :provider_redirect_url, as: :text
    field :url, as: :text
    field :rating, as: :number
    field :rating_count, as: :number
    field :domain, as: :belongs_to
  end
end


