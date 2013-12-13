require 'httparty'

module ReverseGeocoderAPI
  include HTTParty
  headers 'Content-TYpe'=>'application/json'
  base_uri 'http://api.geonames.org'

  def self.lookup(lat, lng, &block)
    options = 
    { 
      :query => 
      { 
        :lat => lat,
        :lng => lng,
        :username => ENV['GEONAMES_USER']
      }
    }
    resp = get("/findNearbyPostalCodesJSON", options)
    yield resp.code, resp.body
  end
end
