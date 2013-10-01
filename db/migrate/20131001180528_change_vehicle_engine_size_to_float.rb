class ChangeVehicleEngineSizeToFloat < ActiveRecord::Migration
  def change
    change_column :vehicles, :engine_size, :float
  end
end
