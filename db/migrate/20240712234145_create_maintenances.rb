class CreateMaintenances < ActiveRecord::Migration[7.1]
  def change
    create_table :maintenances do |t|
      t.references :equipament, null: false, foreign_key: true
      t.string :maintenance_type
      t.date :period_start
      t.date :period_end
      t.decimal :maintenance_value, precision: 10, scale: 2
      t.string :status, limit: 20, default: 'pending'

      t.timestamps
    end
  end
end
