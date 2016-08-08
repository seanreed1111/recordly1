class Artist < ActiveRecord::Base
  validates :name, presence: true

  has_many :albums

  has_many :songs, through: :albums
  has_many :favorites, as: :favoritable #polymorphic

  validates :name, presence: true
end
