class Album < ActiveRecord::Base
  include PgSearch #https://github.com/Casecommons/pg_search
  multisearchable :against => [:name]

  belongs_to :artist

  has_many :collections
  has_many :users, through: :collections

  has_many :songs
  accepts_nested_attributes_for :songs  
  has_many :favorites, as: :favoritable #polymorphic

  pg_search_scope :search_by_name, 
                  :against => :name,
                  :using => 
                  {
                    :tsearch => {:prefix => true, 
                                :any_word => true}
                  }
end
