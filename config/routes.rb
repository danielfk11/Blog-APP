Rails.application.routes.draw do
  devise_for :users, controllers: {
    sessions: 'custom_sessions'
  }

  get "up" => "rails/health#show", as: :rails_health_check

  devise_scope :user do
    delete "/logout" => "sessions#destroy", as: :logout
  end

  # Deslogado:
  root 'posts#index'

  resources :posts, only: [:index, :show, :new, :create, :edit, :update, :destroy] do
    resources :comments, only: [:create, :edit, :update, :destroy]
  end  

  resources :users, only: [:new, :create, :edit, :update]

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

