class CreateStocks < ActiveRecord::Migration[6.0]
  def change
    create_table :stocks do |t|
      t.string :ticker
      t.string :company_name
      t.decimal :price
      t.integer :quantity
      t.timestamps
    end

    create_table :user_stocks do |t|
      t.belongs_to :user
      t.belongs_to :stock
      t.decimal :average_price
      t.timestamps
    end

    add_index :stocks, :ticker,          unique: true
    add_index :stocks, :company_name,    unique: true
  end
end
