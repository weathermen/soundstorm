Rails.application.routes.draw do
  # user management
  devise_for :users

  # rest api
  resource :search, only: %i[show]
  resources :tracks, except: %i[index show]
  resources :likes, only: %i[index]
  resources :users, path: '', only: %i[show] do
    resources :tracks, path: '', only: %i[show] do
      member do
        post :listen
      end
      resources :comments, except: %i[index new]
      resource :like, only: %i[create destroy]
    end
    resource :follow, only: %i[create destroy]
  end

  # activitypub
  get '/.well-known/webfinger', to: 'users#webfinger', format: :json, as: :webfinger
  post :inbox, to: 'versions#create'

  # dashboard
  root to: 'application#index'
end
