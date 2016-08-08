class Song < ActiveRecord::Base
  include PgSearch
  multisearchable :against => [:name]
  belongs_to :artist
  belongs_to :album

  has_many :favorites, as: :favoritable
  validates :name, presence: true

  #class method. Exact and partial matches
  pg_search_scope :search_by_name, 
                  :against => :name,
                  :using => 
                  {
                    :tsearch => {:prefix => true, 
                                :any_word => true}
                  }
end
