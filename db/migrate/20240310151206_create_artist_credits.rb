class CreateArtistCredits < ActiveRecord::Migration[7.1]
  def change
    create_table :artist_credits, id: false do |t|
      t.bigserial :id, primary_key: true
      t.string :name, null: false
    end
  end
end
