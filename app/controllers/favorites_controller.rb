class FavoritesController < ApplicationController
  before_action :authenticate_user!
  before_action :load_favoritable, except: [:index]

  def index
    @albums = current_user.favorited_albums
    @artists = current_user.favorited_artists
    @songs = current_user.favorited_songs    
  end

  def new
    # @album = Album.find(params[:album_id])
    # @favorite = @favoritable.favorites.new(user_id: current_user.id)
    # redirect_to controller: :favorites, action: create, id:@album.id, favoritable_type: @favorite.favoritable_type
  end

  def create
    @favorite = @favoritable.favorites.new(user_id: current_user.id)
    if @favorite.save
      redirect_to :back, notice: 'Favorite has been created'
    else
      #redirect_to :back, notice: 'Errors prevented creation of favorite.'
    end
  end

  def destroy
    @favorite = @favoritable.favorites.where(user_id: current_user.id).first
    puts "@favorite = #{@favorite}"
    if @favorite.destroy
  #    redirect_to controller: :favorites, action: :index, alert:'Favorite has been removed'
      redirect_to :back
    end
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

