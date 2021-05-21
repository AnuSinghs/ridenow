class JourneysController < ApplicationController
  def my_journeys
    @journeys = Journey.where(user: current_user)
  end

  def index
    @journeys = Journey.all
  end

  # def show
  #   @journeys = Journey.find(params[:id])
  # end

  def create
    @journey = Journey.new(journey_params)
    @journey.save
    redirect_to journey_path(@journey)
  end

  # def update
  # end

  private
  def journey_params
    params.require(:journey).permit!
  end


end
