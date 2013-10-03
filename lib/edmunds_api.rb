require 'httparty'

module EdmundsAPI
  include HTTParty
  headers 'Content-TYpe'=>'application/json'
  base_uri 'https://api.edmunds.com/v1/api'

  def self.get_vehicle_info(vin, &block)
    options = 
    { 
      :query => 
      { 
        :vin => vin,
        :api_key => ENV['EDMUNDS_API_KEY'],
        :fmt => "json"
      }
    }
    resp = get("/toolsrepository/vindecoder", options)
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
    resp = get("/vehiclephoto/service/findphotosbystyleid", options)
    yield resp.code, resp.body
  end
end
