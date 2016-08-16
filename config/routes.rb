Rails.application.routes.draw do
  devise_for :users

  # resources :albums do
  #   resources :favorites, only: [:create, :destroy]
  # end

  # routes to create and destroy favorites
  post "/albums/:album_id/favorites", to: "favorites#create", as: "album_favorites"
  delete "/albums/:album_id/favorites/:id", to: "favorites#destroy", as: "album_favorite"

  resources :artists do
    resources :favorites, only: [:create, :destroy]
  end

  resources :songs, except: [:new, :create] do
    resources :favorites, only: [:create, :destroy]
  end



  
  # Songs#New, Songs#Create
  get "/albums/:album_id/songs/new", to: "songs#new", as: "new_album_songs"
  post "/albums/:album_id/songs", to: "songs#create", as: "album_songs"


  resources :collections
  resources :favorites, only: [:index]
  
  get 'user/search', to: "user#search", as: "search"
  root "collections#index"
  get '*unmatched_route', to: 'application#not_found'
 end

   #get "/users/:id/albums/:id", to: "collections#show", as: "show_album"
