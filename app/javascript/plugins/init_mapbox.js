import mapboxgl from 'mapbox-gl';
import 'mapbox-gl/dist/mapbox-gl.css';

const fitMapToMarkers = (map, fitPoints) => {
  const bounds = new mapboxgl.LngLatBounds();
  fitPoints.forEach(point => bounds.extend([ point.lng, point.lat ]));
  map.fitBounds(bounds, { padding: 70, maxZoom: 15, duration: 5000 });
};

const initMapbox = () => {
  const mapElement = document.getElementById('map');

  if (mapElement) { // only build a map if there's a div#map to inject into
    mapboxgl.accessToken = mapElement.dataset.mapboxApiKey;
    const map = new mapboxgl.Map({
      container: 'map',
      style: 'mapbox://styles/mapbox/streets-v10',
      center: [103.8198, 1.3521], // starting position
      zoom: 10
    });
    // set the bounds of the map
    var mapBoundary = [[103.560, 1.215], [104.072, 1.487]];
    map.setMaxBounds(mapBoundary);

    // add start and end markers
    const start = JSON.parse(mapElement.dataset.start);
    const end = JSON.parse(mapElement.dataset.end);
    const fitPoints = JSON.parse(mapElement.dataset.fitpoints);
    const listingMarkers = JSON.parse(mapElement.dataset.listingmarkers);


    start.forEach((ele) => {
      const element = document.createElement('div');
      element.className = 'marker';
      element.style.backgroundImage = `url(https://cdn2.iconfinder.com/data/icons/pins-3-1/24/style-three-pin-cicyling--bike-style-map-cycle-gps-cyclist-path-three-person-pin-human-cicyling-maps-navigation-512.png)`;
      element.style.backgroundSize = 'contain';
      element.style.width = '40px';
      element.style.height = '40px';

      new mapboxgl.Marker(element)
        .setLngLat([ ele.lng, ele.lat ])
        .addTo(map);
    });

    end.forEach((ele) => {
      const element = document.createElement('div');
      element.className = 'marker';
      element.style.backgroundImage = `url(https://cdn1.iconfinder.com/data/icons/vote-reward-9/24/race_flag_mark_state_wind-512.png)`;
      element.style.backgroundSize = 'contain';
      element.style.width = '40px';
      element.style.height = '40px';

      new mapboxgl.Marker(element)
        .setLngLat([ ele.lng, ele.lat ])
        .addTo(map);
    });

    listingMarkers.forEach((ele) => {

      if (ele.category === "Eats") {
      const element = document.createElement('div');
      element.className = 'marker';
      element.style.backgroundImage = `url(https://cdn4.iconfinder.com/data/icons/map-pins-2/256/21-512.png)`;
      element.style.backgroundSize = 'contain';
      element.style.width = '35px';
      element.style.height = '35px';

      new mapboxgl.Marker(element)
        .setLngLat([ ele.lng, ele.lat ])
        .addTo(map);
    }
    else {
      const element = document.createElement('div');
      element.className = 'marker';
      element.style.backgroundImage = `url(https://cdn4.iconfinder.com/data/icons/map-pins-2/256/30-512.png)`;
      element.style.backgroundSize = 'contain';
      element.style.width = '35px';
      element.style.height = '35px';

      new mapboxgl.Marker(element)
        .setLngLat([ ele.lng, ele.lat ])
        .addTo(map);
        }
    });

    fitMapToMarkers(map, fitPoints);
  }
};

export default initMapbox;
