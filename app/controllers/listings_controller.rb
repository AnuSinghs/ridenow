class ListingsController < ApplicationController
  skip_before_action :authenticate_user!, only: [:index]

  def index
    @listings = Listing.all
    @origin = params.start
    @destination = params.end
    katong = []
    marinabay= []
  end
end
