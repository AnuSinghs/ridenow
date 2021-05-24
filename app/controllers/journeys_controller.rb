class JourneysController < ApplicationController
  def my_journeys
    @journeys = Journey.where(user: current_user)
  end

  def index
    @journeys = Journey.all
  end

  def show
    @journey = Journey.find(params[:id])
    start_end
    listing_markers
  end

  def create
    @journey = Journey.new(journey_params)
    @journey.user = current_user
    @journey.listings = Listing.where(id: params[:listing_ids])
    if @journey.save
      redirect_to journey_path(@journey)
    end
  end

  # def update
  # end

 private

  def start_end
    start_location = Geocoder.search("#{@journey.origin},Singapore")
    @start = start_location.first.coordinates

    end_location =  Geocoder.search("#{@journey.destination},Singapore")
    @end = end_location.first.coordinates
    @fit_points = [@start, @end]
  end

  def listing_markers
      @listing_markers = @journey.listings.geocoded.map do |listing|
      {
        lat: listing.latitude,
        lng: listing.longitude,
        category: listing.category.name,
        id: listing.id,
        info_window: render_to_string(partial:"shared/info_window", locals: { listing: listing })
      }
    end
  end

  def journey_params
    params.require(:journey).permit!
  end


end
