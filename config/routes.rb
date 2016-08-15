Rails.application.routes.draw do
  devise_for :users

  resources :albums do
    resources :favorites, only: [:create, :destroy]
  end

  resources :artists do
    resources :favorites, only: [:create, :destroy]
  end

  resources :songs, except: [:create] do
    resources :favorites, only: [:create, :destroy]
  end

  resources :albums do
    resource :songs, only: [:create]
  end


  resources :collections
  resources :favorites, only: [:index]
  
  post 'user/search'
  root "collections#index"
 end
