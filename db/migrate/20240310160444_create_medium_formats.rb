class CreateMediumFormats < ActiveRecord::Migration[7.1]
  def change
    create_table :medium_formats, id: false do |t|
      t.bigserial :id, primary_key: true
      t.string :name, null: false
    end
  end
end
