class ListingsController < ApplicationController
  skip_before_action :authenticate_user!, only: [:index]

  def index
    @listings = Listing.all
    @categories = Category.all
    @journey = Journey.new

    #listing_example #function created below

    start_end #function created below
    @listingsgeocode = Listing.by_latitude(@start[0], @end[0]).by_longitude(@start[1], @end[1])
    @listingeats = Listing.by_latitude(@start[0], @end[0]).by_longitude(@start[1], @end[1]).where(category: Category.last)
    @listingsights = Listing.by_latitude(@start[0], @end[0]).by_longitude(@start[1], @end[1]).where(category: Category.first)

    listing_markers
  end

  private

  def start_end
    start_location = Geocoder.search("#{params[:start]},Singapore")
    @start = start_location.first.coordinates

    end_location =  Geocoder.search("#{params[:end]},Singapore")
    @end = start_location.first.coordinates
    @fit_points = [@start, @end]
  end

  def listing_markers
     @listing_markers = @listings.geocoded.map do |listing|
      {
        lat: listing.latitude,
        lng: listing.longitude,
        category: listing.category.name,
        id: listing.id,
        info_window: render_to_string(partial:"shared/info_window", locals: { listing: listing })
      }
    end
  end

  # def listing_example
  #   katong =
  #     [{
  #       lat: 1.307734,
  #       lng: 103.907653
  #     }]

  #   marina_bay =
  #     [{
  #       lat: 1.282534,
  #       lng: 103.847962
  #     }]
  #   if params[:start] == "Katong"
  #     @start = katong
  #     @end = marina_bay
  #   else
  #     @start = marina_bay
  #     @end = katong
  #   end
  # end
end
