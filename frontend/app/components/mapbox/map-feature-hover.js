import Component from '@ember/component';
import { action } from '@ember-decorators/object';

export default class MapboxMapFeatureHoverComponent extends Component {
  // required
  // option
  map = {};

  // layer to query
  layerId = '';

  hoveredFeature = {};

  mousePosition = {};

  @action
  didHoverLayer(e) {
    const { point, target } = e;
    const [feature] = target.queryRenderedFeatures(point, { layers: [this.layerId] });

    this.set('mousePosition', point);
    this.set('hoveredFeature', feature);
  }
}
