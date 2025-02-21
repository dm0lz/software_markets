class Avo::Resources::SearchEngineResult < Avo::BaseResource
  # self.includes = []
  # self.attachments = []
  # self.search = {
  #   query: -> { query.ransack(id_eq: params[:q], m: "or").result(distinct: false) }
  # }
  
  def fields
    field :id, as: :id
    field :search_engine_results_page, as: :belongs_to
    field :query, as: :text
    field :link, as: :text
    field :title, as: :text
    field :description, as: :textarea
  end
end


