class RenameConfirmationTokenToEmailChangeToken < ActiveRecord::Migration[7.1]
  def change
    rename_column :users, :confirmation_token, :email_change_token
    rename_column :users, :confirmation_sent_at, :email_change_token_sent_at

    add_index :users, :email_change_token, unique: true, where: "email_change_token IS NOT NULL"
  end
end
