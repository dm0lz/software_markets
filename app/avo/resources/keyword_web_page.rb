class Avo::Resources::KeywordWebPage < Avo::BaseResource
  # self.includes = []
  # self.attachments = []
  # self.search = {
  #   query: -> { query.ransack(id_eq: params[:q], m: "or").result(distinct: false) }
  # }
  
  def fields
    field :id, as: :id
    field :keyword, as: :belongs_to
    field :web_page, as: :belongs_to
    field :domain, as: :belongs_to
  end
end


