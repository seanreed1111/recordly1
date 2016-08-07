class RemoveUserFromAlbum < ActiveRecord::Migration
  def change
    remove_reference :albums, :user
  end
end
