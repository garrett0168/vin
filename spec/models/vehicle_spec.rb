require 'spec_helper'

module EdmundsMockAPI
  module Lambo
    def self.get_vehicle_info(vin, &block)
      json = File.read("#{Rails.root}/test/fixtures/lambo.json")
      yield 200, json
    end

    def self.get_vehicle_images(style_id, &block)
      json = File.read("#{Rails.root}/test/fixtures/lambo_photos.json")
      yield 200, json
    end
  end

  module Camry
    def self.get_vehicle_info(vin, &block)
      json = File.read("#{Rails.root}/test/fixtures/camry.json")
      yield 200, json
    end

    def self.get_vehicle_images(style_id, &block)
      yield 404, nil
    end
  end

  module PermissionDenied
    def self.get_vehicle_info(vin, &block)
      yield 403, nil
    end

    def self.get_vehicle_images(style_id, &block)
      yield 403, nil
    end
  end

  module NotFound
    def self.get_vehicle_info(vin, &block)
      yield 404, nil
    end

    def self.get_vehicle_images(style_id, &block)
      yield 404, nil
    end
  end

  module BadRequest
    def self.get_vehicle_info(vin, &block)
      yield 400, nil
    end

    def self.get_vehicle_images(style_id, &block)
      yield 400, nil
    end
  end
end

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

  it "auto capitalizes the vin" do
    vehicle = FactoryGirl.create(:vehicle, vin: "asdf1234asdf")
    vehicle.vin.should == "ASDF1234ASDF"
  end

  describe "vin decoding" do
    before(:each) do
      @vin = "ZHWUC1ZD5DLA01714"
    end

    it "can decode a vin" do
      vehicle = Vehicle.decode_vin(EdmundsMockAPI::Lambo, @vin)

      vehicle.should_not be_nil
      vehicle.vin.should == @vin
      vehicle.make.should == "Lamborghini"
      vehicle.model.should == "Aventador"
      vehicle.transmission_type.should == "AUTOMATED_MANUAL"
      vehicle.engine_type.should == "gas"
      vehicle.engine_cylinders.should == 12
      vehicle.engine_size.should == 6.5
      vehicle.trim.should == "LP 700-4"
      vehicle.name.should == "LP 700-4 2dr Coupe AWD (6.5L 12cyl 7AM)"
      vehicle.style_id.should == 200442000

      # a vehicle without a trim
      vin = "4T1BD1FK2DU092184"
      vehicle = Vehicle.decode_vin(EdmundsMockAPI::Camry, vin)

      vehicle.should_not be_nil
      vehicle.vin.should == vin
      vehicle.make.should == "Toyota"
      vehicle.model.should == "Camry Hybrid"
      vehicle.transmission_type.should == "AUTOMATIC"
      vehicle.engine_type.should == "hybrid"
      vehicle.engine_cylinders.should == 4
      vehicle.engine_size.should == 2.5
      vehicle.trim.should be_nil
      vehicle.style_id.should == nil
    end

    it "can create images while decoding a vin" do
      vehicle = Vehicle.decode_vin(EdmundsMockAPI::Lambo, @vin)

      vehicle.should_not be_nil
      vehicle.vehicle_images.length.should == 13

      vi = vehicle.vehicle_images.last
      vi.author_names.should == "Automobili Lamborghini Holding SpA"
      vi.caption.should == "2012 Lamborghini Aventador LP 700-4 Interior"
      vi.image_type.should == "interior"
      vi.low_res_url.should == "/lamborghini/aventador/2012/oem/2012_lamborghini_aventador_coupe_lp-700-4_i_oem_1_150.jpg"
      vi.medium_res_url.should == "/lamborghini/aventador/2012/oem/2012_lamborghini_aventador_coupe_lp-700-4_i_oem_1_276.jpg"
      vi.high_res_url.should == "/lamborghini/aventador/2012/oem/2012_lamborghini_aventador_coupe_lp-700-4_i_oem_1_423.jpg"
    end

    it "can handle errors gracefully" do
      vehicle = Vehicle.decode_vin(EdmundsMockAPI::PermissionDenied, @vin)
      vehicle.should be_nil

      vehicle = Vehicle.decode_vin(EdmundsMockAPI::NotFound, @vin)
      vehicle.should be_nil

      vehicle = Vehicle.decode_vin(EdmundsMockAPI::BadRequest, @vin)
      vehicle.should be_nil
    end
  end
end
