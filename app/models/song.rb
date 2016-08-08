class Song < ActiveRecord::Base
  before_save :validate_uniqueness_of_song_in_album


  include PgSearch
  multisearchable :against => [:name]
  belongs_to :artist
  belongs_to :album
  has_many :favorites, as: :favoritable

  validates :name, presence: true


# #these aren't working. need a custom validator
#   # validates_uniqueness_of :name, scope: :album, case_sensitive: false
#   # validates :name, scope: :album, uniqueness: {case_sensitive: false}
#   #https://rails.lighthouseapp.com/projects/8994/tickets/2160-nested_attributes-validates_uniqueness_of-fails
#   validates :name, uniqueness: {case_sensitive: false}

#
# how my custom validator should work....
# before adding a song to an album
# check to see if the album already has a song of the same name
# if it does then don't add song to album
#check for exact matches

 
  #class method. Exact and partial matches
  pg_search_scope :search_by_name, 
                  :against => :name,
                  :using => 
                  {
                    :tsearch => {:prefix => true, 
                                :any_word => true}
                  },
                  :ignoring => :accents

  def validate_uniqueness_of_song_in_album
    return true if !self.album_id #no associated album
    
    #now check the album and make sure there are no
    #songs on there with a duplicate name
  end

end
