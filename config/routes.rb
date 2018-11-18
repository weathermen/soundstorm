Rails.application.routes.draw do
  devise_for :users

  resource :search
  resources :tracks, except: %i[index show]
  resources :users, path: '', only: %i[show] do
    resources :tracks, path: '', only: %i[show] do
      member do
        post :listen
      end
      resources :comments, except: %i[index]
    end
    resource :follow, only: %i[create destroy]
    resource :like, only: %i[create destroy]
  end

  get '/.well-known/webfinger', to: 'users#webfinger', format: :json, as: :webfinger
  get :inbox, to: 'versions#create'

  root to: 'application#index'
end
