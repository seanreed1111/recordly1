class CreateFavorites < ActiveRecord::Migration
  def change
    create_table :favorites do |t|
      t.references :user, index: true, foreign_key: true
      t.integer :favoritable_id, index: true, foreign_key: true
      t.string :favoritable_type, index: true, foreign_key: true
      t.timestamps null: false
    end
    add_index :favorites, [:favoritable_id, :favoritable_type], unique: true
  end
end
