Rails.application.routes.draw do
  devise_for :users

  resources :albums do
    resources :favorites, only: [:create, :destroy]
  end

  resources :artists do
    resources :favorites, only: [:create, :destroy]
  end

  resources :songs, except: [:new, :create] do
    resources :favorites, only: [:create, :destroy]
  end

  # get "/users/:id/albums/:id", to: "collections#show", as: "show_album"
  
  # get "/albums/:album_id/songs/new", to: "songs#new", as: "new_album_songs"
  # post "/albums/:album_id/songs", to: "songs#create", as: "album_songs"

  resources :albums do
    resource :songs, only: [:new, :create]
  end


  resources :collections
  resources :favorites, only: [:index]
  
  post 'user/search'
  root "collections#index"
 end
