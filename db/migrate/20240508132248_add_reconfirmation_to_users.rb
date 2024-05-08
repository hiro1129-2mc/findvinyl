class AddReconfirmationToUsers < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :new_email, :string
    add_column :users, :confirmation_token, :string
    add_column :users, :confirmation_sent_at, :datetime
  end
end
