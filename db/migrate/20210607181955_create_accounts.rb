class CreateAccounts < ActiveRecord::Migration[6.1]
  def change
    create_table :accounts do |t|
      t.decimal :balance, null: false, default: 0, precision: 12, scale: 2

      t.timestamps
    end
  end
end
