class CollectionsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_collection, only:[:show, :edit, :update, :destroy]
  before_action :set_album, only: [:show, :edit, :update]


  def index
    @albums = current_user.albums
  end

  def new
    @album = current_user.albums.new
    @collection = current_user.collections.new
    @url = collections_path
    @method = :post
  end

  def create
    puts "params = #{params}"
    puts "album_params = #{album_params}"
    puts "artist_params = #{artist_params}"

    puts "album_params[:name] = #{album_params[:name]}"
    puts "artist_params[:name] = #{artist_params[:name]}"

    @album = current_user.albums.new(album_params)
   


    respond_to do |format|
      if (@album.save)
        current_user.add_artist_to_album!(@album, artist_params[:name])
        @collection = current_user.collections.create(album_id: @album.id)
        format.html { redirect_to collections_path, 
          notice: "Album was successfully added to your collection." }
    #   format.json { render :show, status: :created, location: @user }
      else
        format.html { render :new, 
          notice: 'Errors prevented this form from being saved.' }
    #   format.json { render json: @collection_form.errors, status: :unprocessable_entity }
      end
    end
  end

  def edit
    @url = "\/collections\/#{@collection.id}"
    @method = :put
  end

  def update
    respond_to do |format|
      if (@album.update(album_params))
        format.html { redirect_to collections_path, notice: "Album was successfully added to your collection." }
      #   format.json { render :show, status: :created, location: @user }
      else
          format.html { render :update, 
            alert: 'Errors prevented this form from being saved.' }
      #   format.json { render json: @collection_form.errors, status: :unprocessable_entity }
      end
    end
  end

  def show

  end

  def destroy
    @collection.destroy
    respond_to do |format|
      format.html { redirect_to collections_url, notice: 'Album was successfully removed.' }
      format.json { head :no_content }
    end
  end

  private

  def set_collection
    @collection = Collection.find(params[:id])
  end

  def set_album
    @album = Album.find(@collection.album_id)
  end

  def set_artist_to_album

  end

  def album_params
     params.require(:album).permit(:name)
  end

  def artist_params
     params.require(:artist).permit(:name)
  end


  def collection_params
    params.require(:collection).permit(:id, :user_id, :album_id, :album, album_attributes: [:name, :id, artist_attributes:[:name, :id]])
  end

end