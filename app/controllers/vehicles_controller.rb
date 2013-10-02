class VehiclesController < ApplicationController

  def index
    @vehicles = Vehicle.all
    respond_to do |format|
      format.json { render json: @vehicles.to_json }
    end
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

    respond_to do |format|
      format.json { render json: @vehicle.to_json, status: @vehicle.nil? ? 404 : 200 }
    end
    
  end

end
