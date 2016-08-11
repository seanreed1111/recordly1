class Album < ActiveRecord::Base

  include PgSearch #https://github.com/Casecommons/pg_search
  multisearchable :against => [:name]

  belongs_to :artist
  # validates_uniqueness_of :name,
  #                         conditions: -> 
   #                         {where self.artist.albums 
   #                        (excluding self ) 
  #                           do not have name: self.name
  has_many :collections
  has_many :users, through: :collections

  has_many :songs
  accepts_nested_attributes_for :songs  
  has_many :favorites, as: :favoritable #polymorphic
  validates :name, presence: true

  def my_collection
    self.collections.where(album_id: self.id).first
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
