class CreateMedia < ActiveRecord::Migration[7.1]
  def change
    create_table :mediums, id: false do |t|
      t.bigserial :id, primary_key: true
      t.references :release, null: false, foreign_key: true
      t.references :medium_format, foreign_key: true
  end
end
end
