class ColorsVehicle < ActiveRecord::Base
  belongs_to :color
  belongs_to :vehicle
end

