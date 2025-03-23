Rails.application.routes.draw do
  mount Avo::Engine, at: Avo.configuration.root_path
  mount OasRails::Engine => "/docs"
  resource :session
  resources :passwords, param: :token
  resource :registrations, only: [ :new, :create ]

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  resource :registrations, only: [ :new, :create ]

  namespace :public, path: "/" do
    get "home", to: "home#index"
    resources :markets, only: [ :index, :show ]
    resources :companies, only: [ :index, :show ]
    resources :domains, only: [ :index, :show ]
    resources :domain_emails, only: [ :index, :create ]
    root "markets#index"
  end

  namespace :admin do
    resources :feature_extraction_queries
  end

  namespace :app, path: "/app" do
    resources :users, only: [ :show ]
    root "users#show"
  end

  namespace :api, defaults: { format: :json } do
    namespace :v1 do
      get "home/index"
      get "serp", to: "serp#index"
      get "domain_emails", to: "domain_emails#index"
      get "company_domain", to: "company_domain#index"
      post "web_page", to: "web_page#create"
      post "web_pages", to: "web_pages#create"
    end
  end

  # Defines the root path route ("/")
  root "public/home#index"
end
