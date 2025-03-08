class Avo::Resources::FeatureExtractionQuery < Avo::BaseResource
  # self.includes = []
  # self.attachments = []
  # self.search = {
  #   query: -> { query.ransack(id_eq: params[:q], m: "or").result(distinct: false) }
  # }
  
  def fields
    field :id, as: :id
    field :content, as: :textarea
    field :embedding, as: :text
    field :search_field, as: :text
  end
end


