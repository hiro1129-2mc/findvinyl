class CreateReleases < ActiveRecord::Migration[7.1]
  def change
    create_table :releases, id: false do |t|
      t.bigserial :id, primary_key: true
      t.uuid :gid, null: false
      t.string :name, null: false
      t.references :artist_credit, null: false, foreign_key: true
    end

    add_index :releases, :name
  end
end
