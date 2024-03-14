class CreateItems < ActiveRecord::Migration[7.1]
  def change
    create_table :items do |t|
      t.references :user, null: false, foreign_key: true
      t.references :title, null: false, foreign_key: true
      t.references :artist_name, null: false, foreign_key: true
      t.references :press_country, foreign_key: true
      t.references :matrix_number, foreign_key: true
      t.references :condition, foreign_key: true
      t.text :user_note
      t.integer :role, null: false, default: 0
      t.timestamps
    end
  end
end
