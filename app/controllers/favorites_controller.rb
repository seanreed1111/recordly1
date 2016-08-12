class FavoritesController < ApplicationController
  before_action :authenticate_user!
  before_action :load_favoritable, except: [:index]

  def index
    @albums = current_user.favorites.albums
    @artists = current_user.favorites.artists
    @songs = current_user.favorites.songs
  end

  def new
    # @album = Album.find(params[:album_id])
    # @favorite = @favoritable.favorites.new(user_id: current_user.id)
    # redirect_to controller: :favorites, action: create, id:@album.id, favoritable_type: @favorite.favoritable_type
  end

  def create
    @album = Album.find(params[:album_id])
    @favorite = @favoritable.favorites.new(user_id: current_user.id)
    if @favorite.save
      redirect_to favorites_path, notice: 'Favorite has been created'
    else
      #redirect_to favorites_path, notice: 'Errors prevented creation of favorite.'
    end
  end

  def destroy
  end

  private

  # def favorites_params
  #   params.require(:favorites).permit(:favoritable_id, :favoritable_type, :user_id)
  # end


  def load_favoritable
    @request = request
    @resource, @id = request.path.split('/')[1,2]
    @favoritable = @resource.singularize.classify.constantize.find(@id)
  end
end



# this is what the favorites table looks like
# create_table "favorites", force: :cascade do |t|
#     t.integer  "user_id"
#     t.integer  "favoritable_id"
#     t.string   "favoritable_type"
#   end
