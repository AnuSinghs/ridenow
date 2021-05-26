import mapboxgl from 'mapbox-gl';
import 'mapbox-gl/dist/mapbox-gl.css';

const fitMapToMarkers = (map, fitPoints) => {
  const bounds = new mapboxgl.LngLatBounds();
  fitPoints.forEach(point => bounds.extend([ point[1], point[0] ]));
  map.fitBounds(bounds, { padding: 70, maxZoom: 15, duration: 5000 });
};

const mapListingMarkers = {};
const openInfoWindow = (mapListingMarkers) => {
  //Select all cards
  const cards = document.querySelectorAll('.route-tile');
  cards.forEach((card) => {
    // Put a mic on each card listening for a mouseenter event
    card.addEventListener('mouseenter', (e) => {
      // Here we trigger the display of a corresponding marker infoWondow with the "togglePopup" function provided by mapbox-gl
      mapListingMarkers[e.currentTarget.id].togglePopup();
    });
    // Put a mic listening for a mouselevel event to close the modal when user doesnt hover the card anymore
    card.addEventListener('mouseleave', (e) => {
      mapListingMarkers[e.currentTarget.id].togglePopup();
    });
  });
};

const toggleCardHighlighting = (event) => {
  // Select the card corresponding to the marker's id
  const card = document.querySelector(`[data-listing-id="${event.currentTarget.dataset.markerId}"]`);
  // Toggle the class "highlight" to the card
  card.classList.toggle("highlight");
  mapListingMarkers["listing-" + event.currentTarget.dataset.markerId].togglePopup()
};

const toggleCardScroll = (event) => {
  // Select the card corresponding to the marker's id
  const card = document.querySelector(`[data-listing-id="${event.currentTarget.dataset.markerId}"]`);
  // Toggle the class "highlight" to the card
  window.scroll({
    behavior: 'smooth',
    left: 0,
    top: card.offsetTop - 400
  });
  mapListingMarkers["listing-" + event.currentTarget.dataset.markerId].togglePopup()
};

const initMapboxListings = () => {
  const mapElement = document.getElementById('map-listing');

  if (mapElement) { // only build a map if there's a div#map to inject into
    mapboxgl.accessToken = mapElement.dataset.mapboxApiKey;

    const map = new mapboxgl.Map({
      container: 'map-listing',
      style: 'mapbox://styles/mapbox/streets-v10',
      center: [103.8198, 1.3521], // starting position
      zoom: 10
    });

    // set the bounds of the map
    // var mapBoundary = [[103.560, 1.215], [104.072, 1.487]];
    // map.setMaxBounds(mapBoundary);
    // add start and end markers
    const start = JSON.parse(mapElement.dataset.start);
    const end = JSON.parse(mapElement.dataset.end);
    // fit map to start and end
    const fitPoints = JSON.parse(mapElement.dataset.fitpoints);
    // add listings (sights & eats) markers
    const listingMarkers = JSON.parse(mapElement.dataset.listingmarkers);

// [1.2, 103]
      const element_start = document.createElement('div');
      element_start.className = 'marker';
      element_start.style.backgroundImage = `url(https://cdn2.iconfinder.com/data/icons/pins-3-1/24/style-three-pin-cicyling--bike-style-map-cycle-gps-cyclist-path-three-person-pin-human-cicyling-maps-navigation-512.png)`;
      element_start.style.backgroundSize = 'contain';
      element_start.style.width = '40px';
      element_start.style.height = '40px';

      new mapboxgl.Marker(element_start)
        .setLngLat([start[1], start[0]])
        .addTo(map);

      const element_end = document.createElement('div');
      element_end.className = 'marker';
      element_end.style.backgroundImage = `url(https://cdn1.iconfinder.com/data/icons/vote-reward-9/24/race_flag_mark_state_wind-512.png)`;
      element_end.style.backgroundSize = 'contain';
      element_end.style.width = '40px';
      element_end.style.height = '40px';

      new mapboxgl.Marker(element_end)
        .setLngLat([ end[1], end[0] ])
        .addTo(map);

    // Store map markers in an array
    listingMarkers.forEach((ele) => {
      const element = document.createElement('div');
      element.className = 'marker';
      element.style.backgroundSize = 'contain';
      element.style.width = '35px';
      element.style.height = '35px';
      if (ele.category === "Eats") {
        element.style.backgroundImage = `url(https://cdn4.iconfinder.com/data/icons/map-pins-2/256/21-512.png)`;
      }
      else {
        element.style.backgroundImage = `url(https://cdn4.iconfinder.com/data/icons/map-pins-2/256/30-512.png)`;
      }
      const popup = new mapboxgl.Popup().setHTML(ele.info_window);
      const newListingMarker = new mapboxgl.Marker(element)
        .setLngLat([ ele.lng, ele.lat ])
        .setPopup(popup)
        .addTo(map);
      mapListingMarkers[`listing-${ele.id}`] = newListingMarker;
      // Use "getElement" function provided by mapbox-gl to access to the marker's HTML and set an ID
      newListingMarker.getElement().dataset.markerId = ele.id;
      // Put a mic on the new marker listening for a mouseenter event on marker on Mapbox
      newListingMarker.getElement().addEventListener('mouseenter', (e) => toggleCardHighlighting(e));
      // Put a mic on listening for a mouseleave event
      newListingMarker.getElement().addEventListener('mouseleave', (e) => toggleCardHighlighting(e));
      // Put a mic on listening for a click
      newListingMarker.getElement().addEventListener('click', (e) => toggleCardScroll(e));
    });

    map.on('load', () => {
      map.resize();
      fitMapToMarkers(map, fitPoints);
      // Give the array of listingMarker to a new function called "openInfoWindow"
      openInfoWindow(mapListingMarkers);
    });
  }
};

export default initMapboxListings;
