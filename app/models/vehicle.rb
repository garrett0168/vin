class Vehicle < ActiveRecord::Base
  validates :vin, :presence => true
  validates_uniqueness_of :vin

  def self.decode_vin(api, vin)
    api::get_vehicle_info(vin) do |code, body|
      if code == 200
        body = JSON.parse(body)
        if body && body["styleHolder"] && body["styleHolder"][0]
          obj = body["styleHolder"][0]
          properties = {vin: vin, make: obj["makeName"], model: obj["modelName"], year: obj["year"],
            transmission_type: obj["transmissionType"], engine_type: obj["engineType"],
            engine_cylinders: obj["engineCylinder"], engine_size: obj["engineSize"]}
          properties.merge!(trim: obj["trim"]["name"]) if obj["trim"]

          Vehicle.create!(properties)
        else
          Rails.logger.warn "Unexpected JSON in API response: #{body.inspect}"
          return nil
        end
      else
        Rails.logger.error "Encountered error while querying API for VIN #{vin}. Response code: #{code}"
        return nil
      end
    end
  end
end
