class AddUserToAccounts < ActiveRecord::Migration[6.1]
  def change
    add_reference :accounts, :user, foreign_key: {to_table: :users}, null: false
  end
end
