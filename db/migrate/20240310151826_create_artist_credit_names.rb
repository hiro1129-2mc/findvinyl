class CreateArtistCreditNames < ActiveRecord::Migration[7.1]
  def change
    create_table :artist_credit_names do |t|
      t.references :artist_credit, null: false, foreign_key: true
      t.references :artist, null: false, foreign_key: true
    end
  end
end
