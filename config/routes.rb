Rails.application.routes.draw do
  devise_for :users

  # resources :artists 
  # resources :albums
  # resources :songs
  resources :collections
  resources :favorites, only: [:index, :new, :create, :destroy]

  root "collections#index"
 end
