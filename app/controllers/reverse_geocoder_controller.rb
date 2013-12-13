class ReverseGeocoderController < ApplicationController

  def lookup
    ReverseGeocoderAPI.lookup(params[:lat], params[:lng]) do |code, body|
      respond_to do |format|
        format.json { render json: body, status: code }
      end
    end
  end

end
