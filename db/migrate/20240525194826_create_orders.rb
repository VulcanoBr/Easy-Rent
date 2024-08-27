class CreateOrders < ActiveRecord::Migration[7.1]
  def change
    create_table :orders do |t|
      t.references :customer, null: false, foreign_key: true
      t.references :equipament, null: false, foreign_key: true
      t.string :order_code
      t.date :period_start, null: false
      t.date :period_end
      t.string :status, limit: 20, default: 'pending'
      t.decimal :rent_value, precision: 10, scale: 2
      t.decimal :tot_rent_value, precision: 10, scale: 2

      t.string :payment_method
      t.integer :installments
      t.string :pix_code
      t.string :ticket_barcode

      t.timestamps
    end
    add_index :orders, :status
  end
end
