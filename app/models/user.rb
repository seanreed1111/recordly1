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


  def favorite?(object)
    self.favorite(object).present?
  end

  def favorite(object)
    object_class_name = object.class.to_s
    self.favorites.where(favoritable_id: object.id).where(favoritable_type: object_class_name).first
  end

  def album_ids
    self.collections.map {|collection| collection.album_id}
  end

  def song_ids
    self.songs.map {|song| song.id}
  end

  def artist_ids
    self.artists.map {|artist| artist.id}
  end

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

  PgSearch.multisearch_options = {
    using: {
      tsearch: {
        prefix: true,
        any_word: true,
        dictionary: 'english'
      }
    }
  }
end
