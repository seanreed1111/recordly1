class FavoritesController < ApplicationController
  before_action :authenticate_user!

  def index
    @albums = current_user.favorites.albums
    @artists = current_user.favorites.artists
    @songs = current_user.favorites.songs
  end

  def new

  end

  def create
  end

  def destroy
  end
end

private

def favorites_params
  params.require(:favorites).permit(:favoritable_id, :favoritable_type)
end

# convenience methods
  # current_user.favorite?(Object) 
  # user.favorites.artists
  # user.favorites.songs
  # user.favorites.albums

# this is what the favorites table looks like
# create_table "favorites", force: :cascade do |t|
#     t.integer  "user_id"
#     t.integer  "favoritable_id"
#     t.string   "favoritable_type"
#   end

# Routes for favorites
#    favorites GET    /favorites(.:format)            favorites#index
#              POST   /favorites(.:format)            favorites#create
# new_favorite GET    /favorites/new(.:format)        favorites#new
#     favorite DELETE /favorites/:id(.:format)        favorites#destroy

