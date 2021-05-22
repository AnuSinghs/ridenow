class ListingsController < ApplicationController
  skip_before_action :authenticate_user!, only: [:index]

  def index
    @listings = Listing.all
    @categories = Category.all
    @journey = Journey.new

    listing_example #function created below

    start_end #function created below

    @listingeats = Listing.by_latitude(@start[0][:lat], @end[0][:lat]).by_longitude(@start[0][:lng], @end[0][:lng]).where(category: Category.last)
    @listingsights = Listing.by_latitude(@start[0][:lat], @end[0][:lat]).by_longitude(@start[0][:lng], @end[0][:lng]).where(category: Category.first)

    listing_markers
  end

  private

  def start_end
    @origin = params[:start]
    @destination = params[:end]
    @fit_points = [@start[0], @end[0]]
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

  def listing_example
    katong =
      [{
        lat: 1.307734,
        lng: 103.907653
      }]

    marina_bay =
      [{
        lat: 1.282534,
        lng: 103.847962
      }]
    if params[:start] == "Katong"
      @start = katong
      @end = marina_bay
    else
      @start = marina_bay
      @end = katong
    end
  end
end
