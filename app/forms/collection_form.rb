class CollectionForm < Reform::Form

  property :user_id

  property :album_id

  property :album  do
    property :name
    validates :name, presence: true
  end


end