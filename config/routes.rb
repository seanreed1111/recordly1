Rails.application.routes.draw do
  devise_for :users

  resources :albums, :artists, :songs do
    resources :favorites, only: [:create, :destroy]
  end

  resources :collections
  resources :favorites, only: [:index]
  
  post 'user/search'
  root "collections#index"
 end
