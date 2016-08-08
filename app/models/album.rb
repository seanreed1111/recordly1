class Album < ActiveRecord::Base
  belongs_to :artist

  has_many :collections
  has_many :users, through: :collections

  has_many :songs

end
