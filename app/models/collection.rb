class Collection < ActiveRecord::Base
  belongs_to :user

  belongs_to :album
  accepts_nested_attributes_for :album

  validates_uniqueness_of :user_id, 
                          scope: :album_id,
                          message: "User can only own each unique album once"

end
