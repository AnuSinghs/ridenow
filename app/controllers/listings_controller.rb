class ListingsController < ApplicationController
  skip_before_action :authenticate_user!, only: [:index]

  def index
    @listings = Listing.all
    @categories = Category.all
    @journey = Journey.new

    if params[:start].titleize == params[:end].titleize
      flash[:notice] = "Error with Origin/Destination!"
      redirect_to root_path
    else
      start_end #function created below for finding the coords for start and end
      listing_eats_sights #function created below for storing the eats and sights
      listing_markers(@listingeats, @listingsights) #function created below for storing the details of listing and sending to javascript

      #passing the data to journey controller
      @origin = params[:start]
      @destination = params[:end]
    end
  end

  private

  def start_end
    start_location = Geocoder.search("#{params[:start]},Singapore")
    @start = start_location.first.coordinates
    end_location =  Geocoder.search("#{params[:end]},Singapore")
    @end = end_location.first.coordinates
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
    @listingeats = Listing.where(category: Category.last).by_latitude(@start[0], @end[0]).by_longitude(@start[1], @end[1])
    @listingsights = Listing.where(category: Category.first).by_latitude(@start[0], @end[0]).by_longitude(@start[1], @end[1])
  end
end
