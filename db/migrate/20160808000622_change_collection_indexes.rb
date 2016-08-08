class ChangeCollectionIndexes < ActiveRecord::Migration
  def change
    add_index :collections, [:album_id, :user_id], unique: true

  end
end
