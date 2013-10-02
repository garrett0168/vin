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

  def typeahead_vin
    vin = params[:vin]
    vehicles = Vehicle.where("vin LIKE :prefix", prefix: "#{vin}%").collect { |v| v.vin }
    respond_to do |format|
      format.json { render json: vehicles }
    end
  end

end
