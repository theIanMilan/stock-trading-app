class CreateTransactionRecords < ActiveRecord::Migration[6.0]
  def change
    create_table :transaction_records do |t|
      t.belongs_to :stock
      t.bigint :buyer_id, null: false, foreign_key: { to_table: :users }, index: true
      t.bigint :broker_id, null: false, foreign_key: { to_table: :users }, index: true
      t.integer :transaction_type
      t.decimal :price, precision: 8, scale: 2
      t.integer :quantity
      t.timestamps
    end
  end
end
