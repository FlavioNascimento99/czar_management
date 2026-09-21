Rails.application.routes.draw do
  # Rotas de autenticação
  get "/login", to: "sessions#new"
  post "/login", to: "sessions#create"
  delete "/logout", to: "sessions#destroy"

  # Rotas de usuários
  get "/signup", to: "users#new"
  post "/signup", to: "users#create"

  # Recursos principais
  get "/my_tasks", to: "my_tasks#index", as: :my_tasks
  get "/my_tasks/calendar", to: "my_tasks#calendar", as: :my_tasks_calendar
  namespace :api do
    namespace :v1 do
      resources :projects, only: [ :index, :show ] do
        resources :tasks, only: [ :index, :show, :update ]
      end
    end
  end
  resources :users, only: [ :show ] do
    post "regenerate_token", on: :member
  end
  resources :projects do
    get "board", to: "projects#board", on: :member
    get "calendar", to: "projects#calendar", on: :member
    resources :tags
    resources :tasks do
      resources :comments, only: [ :create, :destroy ]
      delete "files/:attachment_id", to: "tasks#purge_file", on: :member, as: :purge_file
    end
    resources :requirements
    post "members", to: "projects#add_member", on: :member, as: :add_member
    delete "members/:user_id", to: "projects#remove_member", on: :member, as: :remove_member
  end

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Public SaaS landing + logged-in dashboard
  root "pages#home"
end
