class CreateTransactionRecords < ActiveRecord::Migration[6.0]
  def change
    create_table :transaction_records do |t|
      t.belongs_to :user
      t.belongs_to :stock
      t.integer :transaction_type
      t.decimal :price, precision: 8, scale: 2
      t.integer :quantity
      t.timestamps
    end
  end
end
