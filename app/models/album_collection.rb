class AlbumCollection < ActiveRecord::Base
  belongs_to :user
  accepts_nested_attributes_for :user

  belongs_to :album
  accepts_nested_attributes_for :album
end
