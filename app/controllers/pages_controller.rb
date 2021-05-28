class PagesController < ApplicationController
  skip_before_action :authenticate_user!, only: [:home]

  def home
    @journeys = Journey.all
  end

  def editorial
  end

end
