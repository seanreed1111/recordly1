class Album < ActiveRecord::Base
  belongs_to :artist

  has_many :collections
  has_many :users, through: :collections
  accepts_nested_attributes_for :users

  has_many :songs

end
