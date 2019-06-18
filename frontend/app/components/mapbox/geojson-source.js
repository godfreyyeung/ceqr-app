import Component from '@ember/component';
import { computed } from '@ember-decorators/object';

export default class MapboxGeojsonSourceComponent extends Component {
    // public
  // required
  // e-mapbox-gl map object
  map = null;

  // public
  // options used for the mapbox-gl source definition
  options = {};

  /** @param {string} - geojson string */
  geojson = ''

  // sets up source according mapbox-gl source specification
  @computed('geojson')
  get mapboxSourceOptions() {
    return {
      type: 'geojson',
      data: {
        type: "Feature",
        geometry: JSON.parse(this.geojson)
      },
      ...this.options,
    };
  }

}
