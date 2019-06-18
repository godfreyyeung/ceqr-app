import Component from '@ember/component';
import { computed } from '@ember-decorators/object';
import { guidFor } from '@ember/object/internals';

export default class MapboxGeojsonLayerComponent extends Component {
  // public
  layer = {};

  // public
  @computed
  get layerId() {
    return guidFor(this);
  }

  @computed('layer')
  get mapboxLayerOptions() {
    return  {
      id: this.elementId,
      source: this._parentElementId,
      ...this.layer,
    };
  }

  // private
  // used to identify the parent source
  _parentElementId = '';

}
