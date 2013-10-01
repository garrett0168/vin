class CreateVehicles < ActiveRecord::Migration
  def change
    create_table :vehicles do |t|
      t.string :vin, null: false
      t.string :make
      t.string :model
      t.integer :year
      t.string :transmission_type
      t.string :engine_type
      t.integer :engine_cylinders
      t.integer :engine_size
      t.string :trim
    end
  end
end
