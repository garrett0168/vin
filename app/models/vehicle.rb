class Vehicle < ActiveRecord::Base
  validates :vin, :presence => true
  validates_uniqueness_of :vin
end
