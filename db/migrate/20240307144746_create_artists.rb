class CreateArtists < ActiveRecord::Migration[7.1]
  def change
    create_table :artists, id: false do |t|
      t.bigserial :id, primary_key: true
      t.uuid :gid, null: false
      t.string :name, null: false
    end

    add_index :artists, :name
  end
end
