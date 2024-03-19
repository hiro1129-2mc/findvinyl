class CreateArtistNames < ActiveRecord::Migration[7.1]
  def change
    create_table :artist_names do |t|
      t.string :name, null: false
    end
  end
end
