class OptionsVehicle < ActiveRecord::Base
  belongs_to :option
  belongs_to :vehicle
end

