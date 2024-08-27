class CreateEquipaments < ActiveRecord::Migration[7.1]
  def change
    create_table :equipaments do |t|
      t.string :name, null: false
      t.string :serial_number, null: false
      t.string :status, limit: 20, default: 'available'
      t.decimal :rent_value, precision: 10, scale: 2

      t.timestamps
    end
    add_index :equipaments, :serial_number, unique: true
  end
end
