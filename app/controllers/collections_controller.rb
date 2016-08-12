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
    @album = current_user.albums.new(album_params)
    respond_to do |format|
      if (@album.save)
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
            notice: 'Errors prevented this form from being saved.' }
      #   format.json { render json: @collection_form.errors, status: :unprocessable_entity }
      end
    end
  end

  def show
    #need to pick the correct template to render
    # will be one of 
      #collection/show_album
      #collection/show_song
      #collection/show_artist

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


  def album_params
     params.require(:album).permit(:name, :id)
  end

  def collection_params
    params.require(:collection).permit(:id, :user_id, :album_id, album_attributes: [:name, :id])
  end

end