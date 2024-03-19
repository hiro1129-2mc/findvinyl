class LimitUserNoteLengthInItems < ActiveRecord::Migration[7.1]
  def change
    change_column :items, :user_note, :text, limit: 500
  end
end
