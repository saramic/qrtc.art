class LocationsController < ApplicationController
  def index
    @location = Location.active_sample
    @location = nil unless @location.class == Location
    @qr_svg = @location.qr_svg if @location
  end

  def list
    @locations = Location.all
  end

  def new
    @location = Location.new
  end

  def print
    @locations = Location.where(id: params[:ids])
  end

  def show
    if params[:id].length == Location::LOCATION_CODE_LENGTH
      @location = Location.find_by(code: params[:id])
    else
      @location = Location.find(params[:id])
    end
    @qr_svg = @location.qr_svg
    if @location.status == "pending"
      @location.set_code
      render "edit"
    end
    @count = @location.visits.count
  end

  def edit
    if params[:id].length == Location::LOCATION_CODE_LENGTH
      @location = Location.find_by(code: params[:id])
    else
      @location = Location.find(params[:id])
    end
    @location.set_code
    @qr_svg = @location.qr_svg
    @count = @location.visits.count
    @visits = @location.visits
  end

  def qr
    @location = Location.find(params[:id])
    @location.visits.create(meta_data: {
      user_agent: request.user_agent,
      remote_ip: request.remote_ip
    })
    redirect_to "/#{@location.code}"
  end

  def create
    @locations = []
    params[:number].to_i.times do
      location = Location.new
      location.set_code
      location.save!
      @locations << location
    end
    redirect_to print_locations_path(ids: @locations.pluck(:id))
  end

  def update
    @location = Location.find(params[:id])
    @location.update!(location_params.merge(status: "active"))
    redirect_to "/#{@location.code}"
  end

  private

  def location_params
    params.require(:location).permit(:name, :address, :latitude, :longitude, :code)
  end
end
