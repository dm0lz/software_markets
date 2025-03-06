class Avo::Resources::WebPageChunk < Avo::BaseResource
  # self.includes = []
  # self.attachments = []
  # self.search = {
  #   query: -> { query.ransack(id_eq: params[:q], m: "or").result(distinct: false) }
  # }
  
  def fields
    field :id, as: :id
    field :web_page, as: :belongs_to
    field :content, as: :textarea
    field :embedding, as: :text
  end
end


