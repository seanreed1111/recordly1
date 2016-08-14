class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :collections
  has_many :albums, through: :collections
  accepts_nested_attributes_for :albums
  
  has_many :artists, through: :albums
  has_many :songs, through: :albums

  has_many :favorites, inverse_of: :user  #polymorphic favorites

  has_many :favorited_albums, through: :favorites,
            source: :favoritable, source_type: 'Album'

  has_many :favorited_artists, through: :favorites,
            source: :favoritable, source_type: 'Artist'

  has_many :favorited_songs, through: :favorites,
          source: :favoritable, source_type: 'Song'

 #(Album, String) -> ()
  def add_artist_to_album!(album_object, artist_name)
    if album_object.artist.name != artist_name
      if(artist_object_blank?(artist_name))
        artist = create_artist_object_with_name!(artist_name)
      else
        artist = find_artist_object_by_name(artist_name)
      end

      album_object.artist.id = artist.id
    end
  end

#(Album, Artist) -> ()
  def add_artist_object_to_album_object!(album_object, artist_object)
    album_object.artist.id = artist_object.id
  end


  # String -> Artist
  def find_artist_object_by_name(artist_name)
    self.artists.where(name: artist_name).first
  end

  # String -> Bool
  def artist_object_present?(artist_name)
    find_artist_object_by_name(artist_name).present?
  end

  # String -> Bool
  def artist_object_blank?(artist_name)
    find_artist_object_by_name(artist_name).blank?
  end

  # String -> Artist
  def create_artist_object_with_name!(artist_name)
    current_user.artists.create(name: artist_name)
  end

# Object -> Bool
  def favorite?(object)
    self.favorite(object).present?
  end

  # Object -> Favorite
  def favorite(object)
    object_class_name = object.class.to_s
    self.favorites.where(favoritable_id: object.id).where(favoritable_type: object_class_name).first
  end

  # [String] -> [PgSearch_object]
  def search(search_string)
    pg_result = PgSearch.multisearch(search_string)
    if pg_result.present?
      albumids = pg_result.where(searchable_type: "Album").map {|item| item.searchable_id}
      songids = pg_result.where(searchable_type: "Song").map {|item| item.searchable_id}
      artistids = pg_result.where(searchable_type: "Artist").map {|item| item.searchable_id}

      search_result = (self.albums.where(id: albumids) + 
                      self.artists.where(id: artistids)+ 
                      self.songs.where(id: songids)).uniq
    end
  end


  # [String] -> [PgSearch_object]
  def search_destructured(search_string)
    search_result = []

    pg_result = PgSearch.multisearch(search_string)
    if pg_result.present?
      albumids = pg_result.where(searchable_type: "Album").map {|item| item.searchable_id}
      songids = pg_result.where(searchable_type: "Song").map {|item| item.searchable_id}
      artistids = pg_result.where(searchable_type: "Artist").map {|item| item.searchable_id}

      search_result << self.albums.where(id: albumids).uniq 
      search_result << self.artists.where(id: artistids).uniq 
      search_result << self.songs.where(id: songids).uniq
    end
    search_result
  end

  PgSearch.multisearch_options = {
    using: {
      tsearch: {
        prefix: true,
        any_word: true,
        dictionary: 'english'
      }
    }
  }

   # [Collection] -> [Integer]
  def album_ids
    self.collections.map {|collection| collection.album_id}
  end

  # [Song] - > [Integer]
  def song_ids
    self.songs.map {|song| song.id}
  end

  # [Artist] -> [Integer]
  def artist_ids
    self.artists.map {|artist| artist.id}
  end
end
