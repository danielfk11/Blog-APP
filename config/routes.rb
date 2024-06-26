Rails.application.routes.draw do
  devise_for :users, controllers: {
    sessions: 'custom_sessions',
    passwords: 'passwords'
  }

  get "up" => "rails/health#show", as: :rails_health_check

  devise_scope :user do
    delete "/logout" => "sessions#destroy", as: :logout
    get 'profile', to: 'users#show', as: :profile # Rota e nome do caminho para o perfil do usuário
  end

  # Deslogado:
  root 'posts#index'

  resources :posts, only: [:index, :show, :new, :create, :edit, :update, :destroy] do
    resources :comments, only: [:create, :edit, :update, :destroy]
  end

  resources :users, only: [:new, :create, :edit, :update, :show] do
    member do
      get 'edit_password'
      patch 'update_password'
    end
  end

  get '/users/sign_in', to: redirect('/login')

  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy'

  get '/forgot_password', to: 'passwords#new'
  post '/forgot_password', to: 'passwords#create'
  get '/verify_token', to: 'passwords#verify_token'
  post '/validate_token', to: 'passwords#validate_token'
  get '/edit_password', to: 'passwords#edit', as: 'edit_password'
  get '/new_password', to: 'passwords#new'
  post '/reset_password', to: 'passwords#reset_password'
  patch '/reset_password', to: 'passwords#update'

  # Logado:
  resources :posts, except: [:index, :show]
end
