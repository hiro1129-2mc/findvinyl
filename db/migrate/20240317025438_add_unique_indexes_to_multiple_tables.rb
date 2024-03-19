class AddUniqueIndexesToMultipleTables < ActiveRecord::Migration[7.1]
  def change
    add_index :accessories, :name, unique: true
    add_index :artist_names, :name, unique: true
    add_index :conditions, :grade, unique: true
    add_index :matrix_numbers, :number, unique: true
    add_index :press_countries, :name, unique: true
    add_index :tags, :name, unique: true
    add_index :titles, :name, unique: true
    add_index :item_tags, [:item_id, :tag_id], unique: true
    add_index :item_accessories, [:item_id, :accessory_id], unique: true
  end
end
