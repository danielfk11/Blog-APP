Rails.application.routes.draw do
  devise_for :users

  get "up" => "rails/health#show", as: :rails_health_check

  # Deslogado: 
  root 'posts#index'

  resources :posts, only: [:index, :show] do
    resources :comments, only: [:create]
  end

  resources :users, only: [:new, :create]

  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy'

  get '/forgot_password', to: 'passwords#new'
  post '/forgot_password', to: 'passwords#create'
  get '/reset_password', to: 'passwords#edit'
  patch '/reset_password', to: 'passwords#update'

  # Logado:
  resources :posts, except: [:index, :show]
  resources :users, only: [:edit, :update]
end
