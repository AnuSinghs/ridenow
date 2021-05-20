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
    const listingSights = JSON.parse(mapElement.dataset.listingsights);
    const listingEats = JSON.parse(mapElement.dataset.listingeats);

    start.forEach((ele) => {
      new mapboxgl.Marker({
        color: "#2CBB73"
      })
        .setLngLat([ ele.lng, ele.lat ])
        .addTo(map);
    });

    end.forEach((ele) => {
      new mapboxgl.Marker({
        color: "#1B512D"
      })
        .setLngLat([ ele.lng, ele.lat ])
        .addTo(map);
    });

    listingSights.forEach((ele) => {
      new mapboxgl.Marker({
        color: "yellow"
      })
        .setLngLat([ ele.lng, ele.lat ])
        .addTo(map);
    });

    listingEats.forEach((ele) => {
      new mapboxgl.Marker({
        color: ele.category === "Eats" ? "#3aaed8": "yellow"
      })
        .setLngLat([ ele.lng, ele.lat ])
        .addTo(map);
    });

    fitMapToMarkers(map, fitPoints);
  }
};

export default initMapbox;
