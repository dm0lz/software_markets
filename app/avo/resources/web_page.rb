class Avo::Resources::WebPage < Avo::BaseResource
  # self.includes = []
  # self.attachments = []
  # self.search = {
  #   query: -> { query.ransack(id_eq: params[:q], m: "or").result(distinct: false) }
  # }

  def fields
    field :id, as: :id
    field :url, as: :text
    field :domain_id, as: :number
    field :summary, as: :textarea
    field :content, as: :textarea
    field :extracted_content, as: :textarea
    field :domain, as: :belongs_to
  end
end
