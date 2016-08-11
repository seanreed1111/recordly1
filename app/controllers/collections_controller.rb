class CollectionsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_collection, only:[:show, :edit, :update]

  #shows all albums in the user's collection
  # access user from current_user method of Devise

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

  #I have a collection.id, and I need to build
  # the associated user and album object
  def edit
    #@collection = current_user.collections.find(id: collection_params[:id])
    #@album = Album.find(id: collection_params[:album_id])
    @album = Album.find(@collection.album_id)
    @url = "\/collections\/#{@collection.id}"
    @method = :put
  end

  def update
    @album = Album.find(@collection.album_id)
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
    @album = Album.find(@collection.album_id)
  end

  def destroy
  end

  private

  def set_collection
    @collection = Collection.find(params[:id])
  end


  def album_params
     params.require(:album).permit(:name, :id)
  end

  def collection_params
    params.require(:collection).permit(:id, :user_id, :album_id, album_attributes: [:name])
  end

end