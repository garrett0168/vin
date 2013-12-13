class Vehicle < ActiveRecord::Base
  validates :vin, :presence => true
  validates_uniqueness_of :vin

  has_many :vehicle_images
  has_many :styles

  has_many :options_vehicles
  has_many :options, :through => :options_vehicles

  has_many :colors_vehicles
  has_many :colors, :through => :colors_vehicles

  before_save do
    vin.upcase!
  end

  def self.decode_vin(api, vin)
    api::get_vehicle_info(vin) do |code, body|
      if code == 200
        body = JSON.parse(body)
        if body
          body["make"] ||= {}
          body["model"] ||= {}
          body["transmission"] ||= {}
          body["engine"] ||= {}
          body["MPG"] ||= {}
          body["categories"] ||= {}

          basicProperties = {vin: vin, make: body["make"]["name"], model: body["model"]["name"],
            transmission_type: body["transmission"]["transmissionType"], engine_type: body["engine"]["type"],
            engine_cylinders: body["engine"]["cylinder"], engine_size: body["engine"]["size"], 
            driven_wheels: body["drivenWheels"], highway_mpg: body["MPG"]["highway"], city_mpg: body["MPG"]["city"],
            manufacturer: body["manufacturer"], category_epa: body["categories"]["EPAClass"], 
            category_primary_body_type: body["categories"]["primaryBodyType"], category_vehicle_style: body["categories"]["vehicleStyle"],
            category_vehicle_type: body["categories"]["vehicleType"]}

          vehicle = Vehicle.create!(basicProperties)

          vehicle.parseColors(body["colors"]) if body["colors"]
          vehicle.parseStyles(body["years"][0]) if body["years"] && body["years"].length > 0
          vehicle.parseOptions(body["options"]) if body["options"]

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
    self.styles.each do |style|
      begin
        api::get_vehicle_images(style.edmunds_id) do |code, body|
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
              style.vehicle_images.create!(author_names: image["authorNames"].join(", "), caption: image["captionTranscript"],
                image_type: image["subType"], low_res_url: image_urls[0].last, medium_res_url: image_urls[1].last, high_res_url: image_urls[2].last)
            end
          else
            Rails.logger.error("Unable to fetch images for: #{style.edmunds_id}. API Response code: #{code}. API Response body: #{body}")
          end
        end
      rescue => e
        Rails.logger.error("Unable to fetch images for vehicle. Reason: #{e.message}")
      end
    end
  end

  def parseColors(json)
    json.each do |categories|
      category = categories["category"]
      categories["options"].each do |option|
        begin
          self.colors.create!({category: category, edmunds_id: option["id"], name: option["name"], equipment_type: option["equipmentType"], availability: option["availability"]})
        rescue => e
          Rails.logger.error("Unable to parse color: #{option}. Reason: #{e.message}")
        end
      end
    end
  end

  def parseStyles(json)
    if json["styles"].length > 0
      year = json["year"]
      json["styles"].each do |style|
        begin
          props = {edmunds_id: style["id"].to_s, name: style["name"], year: year, trim: style["trim"]}
          if style["submodel"]
            props.merge!({body: style["submodel"]["body"], model: style["submodel"]["modelName"]})
          end
          self.styles.create!(props)
        rescue => e
          Rails.logger.error("Unable to parse styles: #{style}. Reason: #{e.message}")
        end
      end
    end
  end

  def parseOptions(json)
    json.each do |categories|
      category = categories["category"]
      categories["options"].each do |option|
        begin
          self.options.create!({category: category, edmunds_id: option["id"], name: option["name"], equipment_type: option["equipmentType"], availability: option["availability"]})
        rescue => e
          Rails.logger.error("Unable to parse option: #{option}. Reason: #{e.message}")
        end
      end
    end
  end
end
