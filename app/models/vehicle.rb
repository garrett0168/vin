class Vehicle < ActiveRecord::Base
  validates :vin, :presence => true
  validates_uniqueness_of :vin

  has_many :vehicle_images

  before_save do
    vin.upcase!
  end

  def self.decode_vin(api, vin)
    api::get_vehicle_info(vin) do |code, body|
      if code == 200
        body = JSON.parse(body)
        if body && body["styleHolder"] && body["styleHolder"][0]
          obj = body["styleHolder"][0]
          properties = {vin: vin, make: obj["makeName"], model: obj["modelName"], year: obj["year"],
            transmission_type: obj["transmissionType"], engine_type: obj["engineType"],
            engine_cylinders: obj["engineCylinder"], engine_size: obj["engineSize"], style_id: obj["id"],
            name: obj["name"]}
          properties.merge!(trim: obj["trim"]["name"]) if obj["trim"]

          vehicle = Vehicle.create!(properties)
          vehicle.fetch_images(api)

          return vehicle
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

  def fetch_images(api)
    if style_id
      begin
        api::get_vehicle_images(style_id) do |code, body|
          if code == 200
            body = JSON.parse(body)
            body.each do |image|
              image["photoSrcs"].sort! do |x, y|
                x =~ /_(\d+)\..*$/
                x1 = $1.to_i
                y =~ /_(\d+)\..*$/
                y1 = $1.to_i
                x1 <=> y1
              end
              image_urls = image["photoSrcs"].each_slice(image["photoSrcs"].length / 3).to_a
              self.vehicle_images.create!(author_names: image["authorNames"].join(", "), caption: image["captionTranscript"],
                image_type: image["subType"], low_res_url: image_urls[0].last, medium_res_url: image_urls[1].last, high_res_url: image_urls[2].last)
            end
          else
            Rails.logger.error("Unable to fetch styles for: #{style_id}. API Response code: #{code}. API Response body: #{body}")
          end
        end
      rescue => e
        Rails.logger.error("Unable to fetch styles for: #{style_id}. Reason: #{e.message}")
      end
    end
  end
end
