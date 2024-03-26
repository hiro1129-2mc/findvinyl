class AddReleaseFormatIdToItems < ActiveRecord::Migration[7.1]
  def change
    add_reference :items, :release_format, foreign_key: true
  end
end
