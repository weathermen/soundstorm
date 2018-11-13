Rails.application.routes.draw do
  concern :commentable do
    resources :comments, except: %i[index]
  end

  devise_for :users

  resources :tracks, except: %i[index show]

  resources :users, path: '', only: %i[show], concerns: :commentable do
    resources :tracks, path: '', only: %i[show], concerns: :commentable
    resource :follow, only: %i[create destroy]
  end

  get '/.well-known/webfinger', to: 'users#webfinger', format: :json, as: :webfinger
  get :inbox, to: 'versions#create'

  root to: 'users#activity'
end
