class CreateRecordItems < ActiveRecord::Migration[7.1]
  def change
    create_table :record_items do |t|
      t.references :record, null: false, foreign_key: true
      t.references :item, null: false, foreign_key: true
      t.timestamps
    end
  end
end
