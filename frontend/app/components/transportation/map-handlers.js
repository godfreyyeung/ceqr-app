import Component from '@ember/component';
import { action } from '@ember-decorators/object';

export default class TransportationMapHandlersComponent extends Component {
  currentHoveredFeatures = [];

  @action
  didHoverLayer(layerId, e) {
    const { point, target } = e;
    const features = target.queryRenderedFeatures(point, { layers: [layerId] });

    this.set('currentHoveredFeatures', features);
  }
}
