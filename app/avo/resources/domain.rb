class Avo::Resources::Domain < Avo::BaseResource
  # self.includes = []
  # self.attachments = []
  # self.search = {
  #   query: -> { query.ransack(id_eq: params[:q], m: "or").result(distinct: false) }
  # }
  
  def fields
    field :id, as: :id
    field :name, as: :text
    field :company_id, as: :number
    field :company, as: :belongs_to
    field :software_applications, as: :has_many
    field :web_pages, as: :has_many
  end
end


