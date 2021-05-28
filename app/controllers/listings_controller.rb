class ListingsController < ApplicationController
  skip_before_action :authenticate_user!, only: [:index, :editorial]

  def index
    @categories = Category.all
    @journey = Journey.new
    if params[:start].titleize == params[:end].titleize
      flash.now[:notice] = "Error with Origin/Destination!"
      redirect_to root_path
    else
      start_end #function created below for finding the coords for start and end
      listing_eats_sights #function created below for storing the eats and sights
      listing_markers(@listingeats, @listingsights) #function created below for storing the details of listing and sending to javascript
      #passing the data to journey controller
      @origin = params[:start]
      @destination = params[:end]
      flash.now[:notice] = "Select listings to create your itinerary!"
    end
  end

  private

  def start_end
    @start_location = Geocoder.search("#{params[:start]},Singapore")
    @start = @start_location.first.coordinates
    @end_location =  Geocoder.search("#{params[:end]},Singapore")
    @end = @end_location.first.coordinates
    @fit_points = [@start, @end]
  end

  def listing_markers(eat_markers, sight_markers)
    @listing_markers = []
    eat_markers.geocoded.each do |listing|
    @listing_markers << {
      lat: listing.latitude,
      lng: listing.longitude,
      category: listing.category.name,
      id: listing.id,
      info_window: render_to_string(partial:"shared/info_window", locals: { listing: listing })
    }
  end

  sight_markers.geocoded.each do |listing|
   @listing_markers << {
      lat: listing.latitude,
      lng: listing.longitude,
      category: listing.category.name,
      id: listing.id,
      info_window: render_to_string(partial:"shared/info_window", locals: { listing: listing })
    }
  end
end

  def listing_eats_sights
    center = Geocoder::Calculations.geographic_center([@start, @end])
    distance= Geocoder::Calculations.distance_between(@start, @end)
    box = Geocoder::Calculations.bounding_box(center, (distance/1.9))

    @listingeats = Listing.where(category: Category.last).within_bounding_box(box).by_tag_eats(params[:tag_eats]).near(@start)
    @listingsights = Listing.where(category: Category.first).within_bounding_box(box).by_tag_sights(params[:tag_sights]).near(@start)
  end

end
