class CollectionsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_album, only: [:show, :edit, :update, :destroy]
  before_action :set_collection, only: [:show, :edit, :update, :destroy]
  before_action :set_collection_form, only: [:new, :create, :edit, :update]

  def index
    @albums = current_user.albums
  end

  def new
  end

  def create
    @collection_form = CollectionForm.new(Collection.new(collection_params))
    
    respond_to do |format|
      if @collection_form.validate(collection_params)
        if @collection_form.save
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
  end

  def edit
    @collection_form = CollectionForm.new(@collection)
  end

  def update
    @collection_form = CollectionForm.new(Collection.new(collection_params))

    respond_to do |format|
      if @collection_form.validate(collection_params)
          @collection.update(collection_params)
          format.html {redirect_to collections_path,
            notice: "Your collection was successfully updated."}
      else
        format.html {render :edit}
      end
    end
  end

  def destroy
    @collection.destroy
    respond_to do |format|
      format.html {redirect_to collections_path,
        notice: 'Album was removed from your collection.'}
      format.json {head :no_content}
    end
  end

  private

    def collection_params
      params.require(:collection).permit(:user_id, :album_id, albums_attributes:[:name, :id])
    end

#    needed for form partial
    def set_album
      @album = Album.find(params[:album_id])
    end

    def set_collection
      @collection = current_user.collections.build(collection_params)
    end

    def set_collection_form
      @collection_form ||= CollectionForm.new(Collection.new)
    end
end
