Rails.application.routes.draw do
  get "requirements/index"
  get "requirements/show"
  get "requirements/new"
  get "requirements/create"
  get "requirements/edit"
  get "requirements/update"
  get "requirements/destroy"
  get "tasks/index"
  get "tasks/show"
  get "tasks/new"
  get "tasks/create"
  get "tasks/edit"
  get "tasks/update"
  get "tasks/destroy"
  get "projects/index"
  get "projects/show"
  get "projects/new"
  get "projects/create"
  get "projects/edit"
  get "projects/update"
  get "projects/destroy"
  # Rotas de autenticação
  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy'
  
  # Rotas de usuários
  get '/signup', to: 'users#new'
  post '/signup', to: 'users#create'
  
  # Recursos principais
  resources :users, only: [:show]
  resources :projects do
    resources :tasks
    resources :requirements
  end
  
  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Defines the root path route ("/")
  root "projects#index"
end
