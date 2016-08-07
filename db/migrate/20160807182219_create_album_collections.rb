class CreateAlbumCollections < ActiveRecord::Migration
  def change
    create_table :album_collections do |t|
      t.references :user, index: true, foreign_key: true
      t.references :album, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
