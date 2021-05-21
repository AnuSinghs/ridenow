class ListingsController < ApplicationController
  skip_before_action :authenticate_user!, only: [:index]

  def index
    @listings = Listing.all
    @categories = Category.all
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
    @fit_points = [@start[0], @end[0]]

    @listing_markers = @listings.geocoded.map do |listing|
      {
        lat: listing.latitude,
        lng: listing.longitude,
        category: listing.category.name,
      }
    end
  end
end
