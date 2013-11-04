class VehiclesController < ApplicationController

  def index
    total_per_page = params[:per_page] || 5
    page = params[:page] || 1
    total_vehicles = Vehicle.count
    @vehicles = Vehicle.offset(total_per_page.to_i  * (page.to_i - 1)).limit(total_per_page.to_i)
    respond_to do |format|
      format.json { render json: {total: total_vehicles, vehicles: @vehicles.as_json(:only => [:id, :vin, :make, :model])} }
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
      format.json { render json: @vehicle.to_json(:include => :vehicle_images), status: @vehicle.nil? ? 404 : 200 }
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
