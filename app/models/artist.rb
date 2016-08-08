class Artist < ActiveRecord::Base
  include PgSearch
  multisearchable :against => [:name]

  has_many :albums
  accepts_nested_attributes_for :albums
  has_many :songs, through: :albums
  has_many :favorites, as: :favoritable #polymorphic

  validates :name, presence: true

  pg_search_scope :search_by_name, 
                  :against => :name,
                  :using => 
                  {
                    :tsearch => {:prefix => true, 
                                :any_word => true}
                  }
end
