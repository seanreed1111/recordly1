class Album < ActiveRecord::Base

  include PgSearch #https://github.com/Casecommons/pg_search
  multisearchable :against => [:name]

  validates :name, presence: true
  has_many :favorites, as: :favoritable #polymorphic
  has_many :collections
  has_many :users, through: :collections
  has_many :songs
  accepts_nested_attributes_for :songs 

  belongs_to :artist
  # validates_uniqueness_of :name,
  #                         conditions: -> 
   #                         {where self.artist.albums 
   #                        (excluding self ) 
  #                           do not have name: self.name



  def my_collection
    self.collections.where(album_id: self.id).first
  end


  PgSearch.multisearch_options = {
    using: {
      tsearch: {
        prefix: true,
        any_word: true,
        dictionary: 'english'
      }
    },
    ignoring: :accents
  }

end
