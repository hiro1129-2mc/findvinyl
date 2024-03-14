class CreatePressCountries < ActiveRecord::Migration[7.1]
  def change
    create_table :press_countries do |t|
      t.string :name, null: false
    end
  end
end
