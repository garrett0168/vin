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

    def self.tmv(zip, style_id)
      yield 404, nil
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

    def self.tmv(zip, style_id)
      yield 404, nil
    end
  end

  module Sonata
    def self.get_vehicle_info(vin, &block)
      json = File.read("#{Rails.root}/test/fixtures/hyundai_sonata.json")
      yield 200, json
    end

    def self.get_vehicle_images(style_id, &block)
      yield 404, nil
    end

    def self.tmv(zip, style_id)
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

    def self.tmv(zip, style_id)
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

    def self.tmv(zip, style_id)
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

    def self.tmv(zip, style_id)
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
      vehicle.driven_wheels.should == "all wheel drive"
      vehicle.manufacturer.should be_nil
      vehicle.highway_mpg.should == "18"
      vehicle.city_mpg.should == "11"
      vehicle.category_epa.should == "Two Seaters"
      vehicle.category_primary_body_type.should == "Car"
      vehicle.category_vehicle_style.should == "Coupe"
      vehicle.category_vehicle_type.should == "Car"

      vehicle.styles.length.should == 1
      style = vehicle.styles.first
      style.trim.should == "LP 700-4"
      style.name.should == "LP 700-4 2dr Coupe AWD (6.5L 12cyl 7AM)"
      style.body.should == "Coupe"
      style.model.should == "Aventador Coupe"
      style.year.should == 2013
      style.edmunds_id.should == "200442000"
    end

    it "can decode a vin with options, colors, and styles" do
      vehicle = Vehicle.decode_vin(EdmundsMockAPI::Sonata, @vin)

      vehicle.should_not be_nil
      vehicle.vin.should == @vin
      vehicle.make.should == "Hyundai"
      vehicle.model.should == "Sonata"
      vehicle.transmission_type.should == "AUTOMATIC"
      vehicle.engine_type.should == "gas"
      vehicle.engine_cylinders.should == 4
      vehicle.engine_size.should == 2.4
      vehicle.driven_wheels.should == "front wheel drive"
      vehicle.manufacturer.should == "Hyundai Motor Corporation"
      vehicle.highway_mpg.should == "35"
      vehicle.city_mpg.should == "24"
      vehicle.category_epa.should == "Large Cars"
      vehicle.category_primary_body_type.should == "Car"
      vehicle.category_vehicle_style.should == "Sedan"
      vehicle.category_vehicle_type.should == "Car"

      vehicle.styles.length.should == 2
      style = vehicle.styles.first
      style.trim.should == "GLS"
      style.name.should == "GLS 4dr Sedan (2.4L 4cyl 6A)"
      style.body.should == "Sedan"
      style.model.should == "Sonata Sedan"
      style.year.should == 2013
      style.edmunds_id.should == "200417702"

      style = vehicle.styles.last
      style.trim.should == "GLS PZEV"
      style.name.should == "GLS PZEV 4dr Sedan (2.4L 4cyl 6A) "
      style.body.should == "Sedan"
      style.model.should == "Sonata Sedan"
      style.year.should == 2013
      style.edmunds_id.should == "200417703"

      vehicle.colors.length.should == 10
      color = vehicle.colors.first
      color.category.should == "Interior"
      color.edmunds_id.should == "200417751"
      color.name.should == "Camel Cloth"
      color.availability.should == "USED"
      color.equipment_type.should == "COLOR"

      color = vehicle.colors[7]
      color.category.should == "Exterior"
      color.edmunds_id.should == "200417749"
      color.name.should == "Z3 | Iridescent Silver Blue Pearl (E)"
      color.availability.should == "USED"
      color.equipment_type.should == "COLOR"

      vehicle.options.length.should == 12
    end

    it "can create images while decoding a vin" do
      vehicle = Vehicle.decode_vin(EdmundsMockAPI::Lambo, @vin)

      vehicle.should_not be_nil
      vehicle.styles.first.vehicle_images.length.should == 13

      vi = vehicle.styles.first.vehicle_images.first
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
