Rails.application.routes.draw do
  devise_for :users

  resources :albums, :artists, :songs do
    resources :favorites, only: [:new, :create, :destroy]
  end

  resources :collections
  resources :favorites, only: [:index]

  root "collections#index"
 end
