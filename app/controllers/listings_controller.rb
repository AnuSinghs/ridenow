class ListingsController < ApplicationController
  skip_before_action :authenticate_user!, only: [:index]

  def index
    @listings = Listing.all
    @categories = Category.all
  end
end
