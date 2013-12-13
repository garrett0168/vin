require 'httparty'

module EdmundsAPI
  include HTTParty
  headers 'Content-TYpe'=>'application/json'
  base_uri 'https://api.edmunds.com'

  def self.get_vehicle_info(vin, &block)
    options = 
    { 
      :query => 
      { 
        :api_key => ENV['EDMUNDS_API_KEY'],
        :fmt => "json"
      }
    }
    resp = get("/api/vehicle/v2/vins/#{vin}", options)
    yield resp.code, resp.body
  end

  def self.get_vehicle_images(style_id, &block)
    options = 
    { 
      :query => 
      { 
        :styleId => style_id,
        :api_key => ENV['EDMUNDS_API_KEY'],
        :fmt => "json"
      }
    }
    resp = get("/v1/api/vehiclephoto/service/findphotosbystyleid", options)
    yield resp.code, resp.body
  end

  def self.tmv(zip, style_id)
    options = 
    { 
      :query => 
      { 
        :styleid => style_id,
        :zip => zip,
        :api_key => ENV['EDMUNDS_API_KEY'],
        :fmt => "json"
      }
    }
    resp = get("/v1/api/tmv/tmvservice/calculatenewtmv", options)
    yield resp.code, resp.body
  end
end
