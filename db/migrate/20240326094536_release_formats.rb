class ReleaseFormats < ActiveRecord::Migration[7.1]
  def change
    create_table :release_formats do |t|
      t.string :name, null: false
    end
  end
end
