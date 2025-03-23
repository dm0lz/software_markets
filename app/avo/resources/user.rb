class Avo::Resources::User < Avo::BaseResource
  # self.includes = []
  # self.attachments = []
  # self.search = {
  #   query: -> { query.ransack(id_eq: params[:q], m: "or").result(distinct: false) }
  # }
  
  def fields
    field :id, as: :id
    field :email_address, as: :text
    field :role, as: :text
    field :api_token, as: :text
    field :sessions, as: :has_many
    field :api_sessions, as: :has_many
  end
end


