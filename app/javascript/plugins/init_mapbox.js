import mapboxgl from 'mapbox-gl';
import 'mapbox-gl/dist/mapbox-gl.css';

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
    var bounds = [[103.560, 1.215], [104.072, 1.487]];
    map.setMaxBounds(bounds);

    // initialize the map canvas to interact with later
    var canvas = map.getCanvasContainer();
  }
};

export default initMapbox;
