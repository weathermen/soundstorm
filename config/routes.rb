# frozen_string_literal: true

Rails.application.routes.draw do
  # user management
  devise_for :users, controllers: { omniauth_callbacks: 'users/omniauth_callbacks' }
  use_doorkeeper

  # errors
  {
    unauthorized: 401,
    payment_required: 402,
    forbidden: 403,
    not_found: 404,
    too_many_requests: 429,
    internal_server_error: 500
  }.each do |id, status|
    get "/#{status}", to: 'errors#show', id: id, as: id
  end

  # rest api
  resource :search, only: %i[show]
  resources :tracks, except: %i[index show]
  resources :releases, except: %i[index show]
  resources :likes, only: %i[index]
  resources :comments, only: %i[show]
  resources :translations
  get :health, to: 'application#health'
  get '/users', to: 'users#index', as: :users
  resources :users, path: '', only: %i[show] do
    member do
      post :inbox, to: 'versions#create'
      get :outbox, to: 'versions#index'
    end

    resource :follow, only: %i[create destroy]
    resources :releases, only: %i[show]
    resources :tracks, path: '', only: %i[show] do
      member do
        post :listen
      end

      resources :comments, except: %i[show]
      resource :like, only: %i[create destroy]
    end
  end

  # activitypub
  get '/.well-known/webfinger', to: 'users#webfinger', format: :json, as: :webfinger
  post :inbox, to: 'versions#create'

  # dashboard
  root to: 'application#splash'
end
