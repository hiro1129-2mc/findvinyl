class SorceryCore < ActiveRecord::Migration[7.1]
  def change
    create_table :users do |t|
      t.string :name,            null: false
      t.string :email,            null: false, index: { unique: true }
      t.string :crypted_password
      t.string :profile_image
      t.integer :role,            null: false, default: 0

      t.timestamps                null: false
    end
  end
end
