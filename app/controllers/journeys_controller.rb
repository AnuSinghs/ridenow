require 'json'
require 'open-uri'
require 'fast_polylines'

class JourneysController < ApplicationController
  def my_journeys
    @journeys = Journey.where(user: current_user)
  end

  def index
    @journeys = Journey.all
  end

  def show
    @journey = Journey.find(params[:id])
    start_end(@journey.origin, @journey.destination)
    listing_markers(@journey.listings.where(category: Category.last), @journey.listings.where(category: Category.first))
  end

  def create
    @journey = Journey.new(journey_params)
    @journey.user = current_user
    @journey.listings = Listing.where(id: params[:listing_ids])
    start_end(params[:journey][:origin], params[:journey][:destination])
    listing_coords = @journey.listings.map do |listing|
      ["#{listing.longitude},#{listing.latitude};"]
    end

    screenshot(listing_coords)

    @journey.route_url = @url_params.join('')
    check_journey_valid
  end

  def edit
    @journey = Journey.find(params[:id])
    @listings = Listing.all
    @categories = Category.all
    start_end(@journey.origin, @journey.destination) #function created below for finding the coords for start and end
    listing_eats_sights #function created below for storing the eats and sights
    listing_markers(@listingeats, @listingsights) #function created below for storing the details of listing and sending to javascript
    authorize @journey
  end

  def update
    @journey = Journey.find(params[:id])
    @journey.update(journey_params)
    @journey.listings = Listing.where(id: params[:listing_ids])
    start_end(@journey.origin, @journey.destination)
    listing_coords = @journey.listings.map do |listing|
      ["#{listing.longitude},#{listing.latitude};"]
    end

    screenshot(listing_coords)

    @journey.route_url = @url_params.join('')
    if @journey.name?
      if @journey.save
        redirect_to journey_path(@journey)
      else
        flash.now[:notice] = "Error in saving the Journey"
        redirect_to edit_journey_path(@journey) 
      end
    else
      flash[:notice] = "Enter Your Journey's Name"
      redirect_to edit_journey_path(@journey)
    end
    authorize @journey
  end
 private

  def start_end(origin, destination)
    start_location = Geocoder.search("#{origin},Singapore")
    @start = start_location.first.coordinates

    end_location =  Geocoder.search("#{destination},Singapore")
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

  def check_journey_valid
    if @journey.name?
      if @journey.save
        redirect_to journey_path(@journey)
      else
        flash[:notice] = "Error in saving the Journey"
        redirect_to 
      end
    else
      flash[:notice] = "Enter Your Journey's Name"
    end
  end

  def journey_params
    params.require(:journey).permit!
  end

  def screenshot(listing_coords)
    #obtain turn by turn coordinates for screenshot
    url_search_params = [
      'https://api.mapbox.com/directions/v5/mapbox/cycling/',
      @start[1],
      ',',
      @start[0],
      ';',
      listing_coords.join(''),
      @end[1],
      ',',
      @end[0],
      "?steps=true&geometries=geojson&access_token=#{ENV['MAPBOX_API_KEY']}",
      ]
      # send get request to mapbox to obtain step by step waypoints
      url_search = url_search_params.join("")
      raw_json = open(url_search).read
      parsed_json = JSON.parse(raw_json)
      decoded_waypoints = parsed_json['routes'].first['geometry']['coordinates']
      reverse_decoded_waypoints = decoded_waypoints.map do |coord|
        coord.reverse
      end
      # select waypoints in intervals of 3
      n = 4
      select_waypoints = []
      select_waypoints << reverse_decoded_waypoints.first
      (n-1).step(reverse_decoded_waypoints.size - 1, n).each do |i|
        select_waypoints << reverse_decoded_waypoints[i]
      end
      select_waypoints << reverse_decoded_waypoints.last
    # obtain screenshot url
    @url_params = [
      'https://api.mapbox.com/styles/v1/mapbox/streets-v10/static/',
      'pin-s+6aec84',
      '(',
      @start[1],
      ',',
      @start[0],
      ')',
      ',',
      'pin-s+02550c',
      '(',
      @end[1],
      ',',
      @end[0],
      ')',
      ',',
      "path-5+f44-0.5(#{FastPolylines.encode(select_waypoints)})",
      '/auto/500x300?',
      "access_token=#{ENV['MAPBOX_API_KEY']}"
    ]
  end
end


