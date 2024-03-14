class CreateItemAccessories < ActiveRecord::Migration[7.1]
  def change
    create_table :item_accessories do |t|
      t.references :item, null: false, foreign_key: true
      t.references :accessory, null: false, foreign_key: true
    end
  end
end
