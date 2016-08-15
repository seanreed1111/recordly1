class SongsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_album, only: [:new, :create]
  before_action :set_song, only: [:show, :edit, :update]

# user inputs song name
#create a new song object with that name
#assign the correct album id to song.album_id
# save and/or update

  def index
    @songs = current_user.songs
  end

  def show
  end

  def new
    @params = params
    @song = @album.songs.new
  end

 
  def edit
  end


  def create
    @song = @album.songs.new(song_params)
    if @album.all_song_names_are_unique_with?(@song.name)
      @song.album_id = @album.id
      respond_to do |format|
        if @song.save      
          format.html { redirect_to @song, notice: 'Song was successfully created.' }
          format.json { render :show, status: :created, location: @song }
        else
          format.html { render :new , alert: "Song has not been created."}
          format.json { render json: @song.errors, status: :unprocessable_entity }
        end
      end
    else
      render :new, alert: "Song name cannot be duplicate."
    end
  end


  def update
    respond_to do |format|
      if @song.update(song_params) #album data must be present
        format.html { redirect_to @song, notice: 'Song was successfully updated.' }
        format.json { render :show, status: :ok, location: @song }
      else
        format.html { render :edit }
        format.json { render json: @song.errors, status: :unprocessable_entity }
      end
    end
  end



  private
    # Use callbacks to share common setup or constraints between actions.
    def set_song
      @song = Song.find(params[:id])
    end

    def set_album
      @album = Album.find(params[:album_id])
    end


    def album_params
      params.require(:album).permit(:name, :id)
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def song_params
      params.require(:song).permit(:name,:id, :album, :album_id)
    end
end
