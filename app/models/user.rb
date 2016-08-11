class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :collections

  has_many :albums, through: :collections
  has_many :artists, through: :albums
  has_many :songs, through: :albums
  
  accepts_nested_attributes_for :albums
  has_many :favorites, inverse_of: :user  #polymorphic favorites

  def album_ids
    self.collections.map {|collection| collection.album_id}
  end

  def song_ids
    self.songs.map {|song| song.id}
  end

  def artist_ids
    self.artists.map {|artist| artist.id}
  end


# TTD 8.2.11.2 Limit Constrained Lookup, p251, The Rails 4 Way
# search results should return..
# 1) Only Albums contained in self.albums, *and*
# 2) Only Artists contained in self.albums.artists, *and*
# 3) Only Songs contained in self.albums.songs 

  def search(search_string)
    pg_result = PgSearch.multisearch(search_string)
    albumids = pg_result.where(searchable_type: "Album").map {|item| item.searchable_id}
    songids = pg_result.where(searchable_type: "Song").map {|item| item.searchable_id}
    artistids = pg_result.where(searchable_type: "Artist").map {|item| item.searchable_id}

    search_result = (self.albums.where(id: albumids) + 
                    self.artists.where(id: artistids)+ 
                    self.songs.where(id: songids)).uniq

  end
end


  #  album_result = result.where(we select the album objects
  #                             and check the id of the album objects
  #                         and return the results only if
  #                          the id is in : self.album_ids)

# example scopes done with the other type of pg-search
  # #make sure this is NOT CASE SENSITIVE
  # pg_search_scope :search_by_name, 
  #                 :against => :name,
  #                 :using => 
  #                 {
  #                   :tsearch => {:prefix => true, 
  #                               :any_word => true}
  #                 },
  #                 :ignoring => :accents
