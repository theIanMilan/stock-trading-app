class CreateOrders < ActiveRecord::Migration[6.0]
  def change
    create_table :orders do |t|
      t.belongs_to :user
      t.belongs_to :stock
      t.integer :type
      t.decimal :price, precision: 8, scale: 2
      t.integer :quantity

      t.timestamps
    end
  end
end
