class CreateFavoritePhotos < ActiveRecord::Migration
  def change
    create_table :favorite_photos do |t|
      t.references :photo, index: true, foreign_key: true
      t.references :user, index: true, foreign_key: true
      t.timestamps null: false
    end
  end
end
