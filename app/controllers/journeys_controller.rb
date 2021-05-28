require 'json'
require 'open-uri'
require 'fast_polylines'
require 'geocoder'

class JourneysController < ApplicationController
  skip_before_action :authenticate_user!, only: [:index, :show]
  def my_journeys
    @journeys = Journey.where(user: current_user)
  end

  def index
    @journeys = Journey.all
  end

  def show
    @journey = Journey.find(params[:id])
    start_end(@journey.origin, @journey.destination)
    listing_markers(@journey.listings)
  end

  def create
    @journey = Journey.new(journey_params)
    @journey.user = current_user
    start_end(params[:journey][:origin], params[:journey][:destination])
    @journey.listings = Listing.where(id: params[:listing_ids]).near(@start, 20)

    listing_coords = @journey.listings.map do |listing|
      ["#{listing.longitude},#{listing.latitude};"]
    end

    screenshot(listing_coords)

    @journey.route_url = @url_params.join('')
    check_journey_valid
  end

  def edit
    @journey = Journey.find(params[:id])
    @categories = Category.all
    start_end(@journey.origin, @journey.destination) #function created below for finding the coords for start and end
    listing_eats_sights #function created below for storing the eats and sights
    markers = @listingeats + @listingsights
    #function created below for storing the details of listing and sending to javascript
    listing_markers(Listing.where(id: markers)) # arrange selected markers according to proximity to origin
    authorize @journey
  end

  def update
    @journey = Journey.find(params[:id])
    @journey.update(journey_params)
    start_end(@journey.origin, @journey.destination)
    @journey.listings = Listing.where(id: params[:journey][:listing_ids]).near(@start, 20)
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
      flash.now[:notice] = "Enter Your Journey's Name"
      redirect_to edit_journey_path(@journey)
    end
    authorize @journey
  end

  def destroy
    @journey = Journey.find(params[:id])
    @journey.destroy
    redirect_to my_journeys_path
  end


  def route_email
    @journey = Journey.find(params[:id])
    JourneyMailer.with(journey: @journey).route_email.deliver_now
    redirect_to journey_path(@journey)
    flash.now[:notice] = "Journey emailed!"
  end

 private

  def start_end(origin, destination)
    start_location = Geocoder.search("#{origin},Singapore")
    @start = start_location.first.coordinates

    end_location =  Geocoder.search("#{destination},Singapore")
    @end = end_location.first.coordinates
    @fit_points = [@start, @end]
  end

  def listing_markers(markers)
    @listing_markers = markers.geocoded.map do |listing|
      {
        lat: listing.latitude,
        lng: listing.longitude,
        category: listing.category.name,
        id: listing.id,
        info_window: render_to_string(partial:"shared/info_window", locals: { listing: listing })
      }
    end
  end

 def listing_eats_sights
    center = Geocoder::Calculations.geographic_center([@start, @end])
    distance= Geocoder::Calculations.distance_between(@start, @end)
    box = Geocoder::Calculations.bounding_box(center, (distance/1.9))

    @listingeats = Listing.where(category: Category.last).within_bounding_box(box).by_tag_eats(params[:tag_eats]).near(@start)
    @listingsights = Listing.where(category: Category.first).within_bounding_box(box).by_tag_sights(params[:tag_sights]).near(@start)
  end

  def check_journey_valid
    if @journey.name?
      if @journey.save
        redirect_to journey_path(@journey)
      else
        flash.now[:notice] = "Error in saving the Journey"
        redirect_to listings_path
      end
    else
      flash.now[:notice] = "Enter Your Journey's Name"
      redirect_to listings_path
    end
  end

  def journey_params
    params.require(:journey).permit!
  end

  def screenshot(listing_coords)
    # obtain turn by turn coordinates from mapbox
    url_search_params = [
      'https://api.mapbox.com/optimized-trips/v1/mapbox/cycling/',
      @start[1],
      ',',
      @start[0],
      ';',
      listing_coords.join(''),
      @end[1],
      ',',
      @end[0],
      "?source=first&destination=last&roundtrip=false&steps=true&geometries=geojson&access_token=#{ENV['MAPBOX_API_KEY']}",
      ]
      # parse the json from mapbox
      url_search = url_search_params.join("")
      raw_json = open(url_search).read
      parsed_json = JSON.parse(raw_json)
      decoded_waypoints = parsed_json['trips'].first['geometry']['coordinates']
      reverse_decoded_waypoints = decoded_waypoints.map do |coord|
        coord.reverse
      end

    # obtain screenshot url
    @url_params = [
      'https://api.mapbox.com/styles/v1/mapbox/streets-v11/static/',
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
      "path-5+5E2BFF-0.7(#{CGI.escape FastPolylines.encode(reverse_decoded_waypoints)})",
      # change image resolution here 1200x630
      '/auto/1200x630?',
      "access_token=#{ENV['MAPBOX_API_KEY']}"
    ]
  end
end


