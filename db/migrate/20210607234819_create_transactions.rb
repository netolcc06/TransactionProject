class CreateTransactions < ActiveRecord::Migration[6.1]
  def change
    create_table :transactions do |t|
      t.decimal :amount, null: false, default: 0, precision: 12, scale: 2
      t.references :source, foreign_key: {to_table: :accounts}, null: false
      t.references :destiny, foreign_key: {to_table: :accounts}, null: false

      t.timestamps
    end
  end
end
