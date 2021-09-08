class CreateStocks < ActiveRecord::Migration[6.0]
  def change
    create_table :stocks do |t|
      t.string :ticker
      t.string :company_name
      t.decimal :last_transaction_price, precision: 8, scale: 2
      t.integer :quantity
      t.timestamps
    end

    create_table :user_stocks do |t|
      t.belongs_to :user
      t.belongs_to :stock
      t.decimal :average_price, precision: 8, scale: 2, default: 0.0
      t.integer :total_shares, default: 0
      t.timestamps
    end

    add_index :stocks, :ticker,          unique: true
    add_index :stocks, :company_name,    unique: true
  end
end
