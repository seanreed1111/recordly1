class CollectionsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_album

  #shows all albums in the user's collection
  # access user from current_user method of Devise

  def index
    @albums = current_user.albums
  end

  def new
    @album = current_user.albums.new
    @collection = current_user.collections.new
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
  end

  def update
  end

  def show
  end

  def destroy
  end

  private

  def set_album

  end

  def album_params
    params.require(:album).permit(:name)
  end

end