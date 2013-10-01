require 'spec_helper'

describe Vehicle do
  it "is not valid without a vin" do
    vehicle = Vehicle.new
    vehicle.should have(1).error_on(:vin)
  end

  it "is must have a unique vin" do
    vehicle = FactoryGirl.create(:vehicle)

    vehicle2 = Vehicle.new(vin: vehicle.vin)
    vehicle2.should have(1).error_on(:vin)

    vehicle2.vin = "ZHWUC1ZD5DLA01714"
    vehicle2.should have(0).errors_on(:vin)
  end
end
