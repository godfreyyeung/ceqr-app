import Component from '@ember/component';
import { keepLatestTask } from 'ember-concurrency-decorators';
import { timeout } from 'ember-concurrency';

export default class MapboxIntersectingFeatures extends Component {
  // required
  // option
  // mapbox-gl instance
  map = {};

  // id of layer to query
  layerId = '';

  // hoveredFeatures
  hoveredFeatures = [];

  // point used to query for intersecting features
  point = {};

  // grabs the intersecting features from mapbox-gl
  @keepLatestTask
  *queryRenderedFeatures(e) {
    const { target, point } = e;

    yield timeout(5);

    const features = target.queryRenderedFeatures(point, {
      layers: [this.layerId],
    });

    this.set('hoveredFeatures', features);
    this.set('point', point);
  }
}
