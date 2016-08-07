class Album < ActiveRecord::Base
  belongs_to :artist
  has_many :users, through: :album_collection

  has_many :songs
  accepts_nested_attributes_for :songs

  validates :name, presence: true

end
