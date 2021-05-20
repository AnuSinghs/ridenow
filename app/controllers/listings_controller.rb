class ListingsController < ApplicationController
  skip_before_action :authenticate_user!, only: [:index]

  def index
    @listings = Listing.all
    @categories = Category.all
    katong =
      [{
        lat: 1.305880,
        lng: 103.900368
      }]

    marina_bay =
      [{
        lat: 1.280600,
        lng: 103.865650
      }]
    if params[:start] == "Katong"
      @start = katong
      @end = marina_bay
    else
      @start = marina_bay
      @end = katong
    end
    @fit_points = [@start[0], @end[0]]

    @listing_markers = @listings.geocoded.map do |listing|
      {
        lat: listing.latitude,
        lng: listing.longitude
      }
    end
  end
end
