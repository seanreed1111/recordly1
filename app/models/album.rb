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
  accepts_nested_attributes_for :artist

 validate :all_song_names_are_unique

 def all_song_names_are_unique
  my_songs = self.songs
  return if my_songs.blank?
  my_song_names = my_songs.map{|song|song.name}
  if (my_song_names.uniq.length != my_song_names.length)
    errors.add(:song_names, "must all be unique")
  end
 end

  def all_song_names_are_unique_with?(song_name)
    result = true
  my_songs = self.songs
  my_song_names = my_songs.map{|song|song.name} << song_name
  if (my_song_names.uniq.length != my_song_names.length)
    result = false
  end
  result
 end


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
    }
  }

end
