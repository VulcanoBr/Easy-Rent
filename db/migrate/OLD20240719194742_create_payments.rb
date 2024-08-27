class CreatePayments < ActiveRecord::Migration[7.1]
  def change
    create_table :payments do |t|
      t.references :order, null: false, foreign_key: true
      t.string :payment_method
      t.decimal :tot_rent_value, precision: 10, scale: 2
      t.integer :installments
      t.string :pix_code
      t.string :ticket_barcode

      t.timestamps
    end
  end
end
