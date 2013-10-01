require 'httparty'

module EdmundsAPI
  include HTTParty
  headers 'Content-TYpe'=>'application/json'
  base_uri 'https://api.edmunds.com/v1/api/toolsrepository'

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
    resp = get("/vindecoder", options)
    yield resp.code, resp.body
  end
end
