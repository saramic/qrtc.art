class LocationsController < ApplicationController
  def index
    location_id = Location.active_sample
    @url = Location.url_for(location_id)
    @qr_svg = Location.qr_svg_for(location_id)
    render "show"
  end

  def new
    @location = Location.new
  end

  def show
    @location = Location.find(params[:id])
    @url = @location.url
    @qr_svg = @location.qr_svg
    render "register" if @location.status == "pending" || params[:edit] == "true"
    @location.visits.create(meta_data: {
      user_agent: request.user_agent,
      remote_ip: request.remote_ip
    })
    @count = @location.visits.count
  end

  def create
    @locations = []
    params[:number].to_i.times do
      @locations << Location.create!
    end
    render "generated", layout: "print"
  end

  def update
    @location = Location.find(params[:id])
    @location.update!(location_params.merge(status: "active"))
    redirect_to "/#{@location.id}"
  end

  private

  def location_params
    params.require(:location).permit(:name, :address, :latitude, :longitude)
  end
end
