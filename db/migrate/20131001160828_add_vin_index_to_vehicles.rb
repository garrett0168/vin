class AddVinIndexToVehicles < ActiveRecord::Migration
  def change
    add_index :vehicles, :vin
  end
end
