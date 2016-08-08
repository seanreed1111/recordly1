class Song < ActiveRecord::Base
  belongs_to :artist
  belongs_to :album

  has_many :favorites, as: :favoritable
  validates :name, presence: true
end
