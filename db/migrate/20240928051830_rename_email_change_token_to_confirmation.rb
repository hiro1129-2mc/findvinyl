class RenameEmailChangeTokenToConfirmation < ActiveRecord::Migration[7.1]
  def change
    rename_column :users, :email_change_token, :confirmation_token
    rename_column :users, :email_change_token_sent_at, :confirmation_sent_at
  end
end
