class VehiclesController < ApplicationController

  def index
    @vehicles = Vehicle.all
  end

  def by_vin
    @vin = params[:vin]
    begin
      @vehicle = Vehicle.where(vin: @vin).first
      unless @vehicle
        @vehicle = Vehicle.decode_vin(EdmundsAPI, @vin)
      end

    rescue => e
      Rails.logger.error "Unable to get vehicle by vin. Reason: #{e.message}"
      flash[:error] = "Unable to get vehicle by vin. Reason: #{e.message}"
      @vehicle = nil
    end
    
  end

end
