Rails.application.routes.draw do
  devise_for :users

  resources :tracks, except: %i[index show]

  resources :users, path: '', only: %i[show] do
    resources :tracks, path: '', only: %i[index show]
  end

  get '/.well-known/webfinger', to: 'users#webfinger'
  get :inbox, to: 'activities#create'

  root to: 'users#activity'
end
