class Avo::Resources::SearchEngineResult < Avo::BaseResource
  # self.includes = []
  # self.attachments = []
  # self.search = {
  #   query: -> { query.ransack(id_eq: params[:q], m: "or").result(distinct: false) }
  # }

  def fields
    field :id, as: :id
    field :site_name, as: :text
    field :url, as: :text
    field :title, as: :text
    field :query, as: :text
    field :description, as: :textarea
    field :position, as: :integer
  end
end
