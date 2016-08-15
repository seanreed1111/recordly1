class ArtistsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_artist, only: [:show, :edit, :update]
  before_action :set_album, only: [:create]
  before_action :set_albums, only: [:show]

  # GET /artists
  # GET /artists.json
  def index
    @artists = current_user.artists
  end

  # GET /artists/1
  # GET /artists/1.json
  def show
  end

  # GET /artists/new
  def new
    @artist = Artist.new
  end

  # GET /artists/1/edit
  def edit
  end

  # POST /artists
  # POST /artists.json
  def create
    @artist = Artist.new(artist_params) #album data must be present

    respond_to do |format|
      if @artist.save
        format.html { redirect_to @artist, notice: 'Artist was successfully created.' }
        format.json { render :show, status: :created, location: @artist }
      else
        format.html { render :new }
        format.json { render json: @artist.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /artists/1
  # PATCH/PUT /artists/1.json
  def update
    respond_to do |format|
      if @artist.update(artist_params) #album data must be present
        format.html { redirect_to @artist, notice: 'Artist was successfully updated.' }
        format.json { render :show, status: :ok, location: @artist }
      else
        format.html { render :edit }
        format.json { render json: @artist.errors, status: :unprocessable_entity }
      end
    end
  end


  private
    def set_artist
      @artist = Artist.find(params[:id])
    end

    def set_album
      @album = Album.find()
    end

    def set_albums
      @albums = current_user.find_albums_by_artist_by_id(@artist.id)
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def artist_params
      params.require(:artist).permit(:name)
    end
end
