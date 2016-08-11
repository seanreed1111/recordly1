class Album < ActiveRecord::Base

  #before_create :validate_uniqueness_of_artist_album_combo

  include PgSearch #https://github.com/Casecommons/pg_search
  multisearchable :against => [:name]

  belongs_to :artist

  has_many :collections
  has_many :users, through: :collections

  has_many :songs
  accepts_nested_attributes_for :songs  
  has_many :favorites, as: :favoritable #polymorphic
  validates :name, presence: true

  def my_collection
    self.collections.where(album_id: self.id).first
  end

  #this does not work!!!! 
  #Need to do this in the db directly
  def validate_uniqueness_of_artist_album_combo
    # in words. self is the album we want to save
    # if artist doesn't have any albums, return true
    #if self.artist is nil, return true

    return true if !self.artist #otherwise albums below is undefined

    return_value = true

    albums_query = self.artist.albums.select {|album| album.name == self.name}

    if albums_query.count > 0
      return_value = false
    end

    return_value
  end

  pg_search_scope :search_by_name, 
                  :against => :name,
                  :using => 
                  {
                    :tsearch => {:prefix => true, 
                                :any_word => true}
                  },
                  :ignoring => :accents


end
