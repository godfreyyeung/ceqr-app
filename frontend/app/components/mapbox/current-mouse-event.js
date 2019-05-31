import Component from '@ember/component';
import { action } from '@ember-decorators/object';

export default class MapboxCurrentMousePositionComponent extends Component {
  mapboxEventName = null;

  currentMapMouseEvent = null;

  @action
  handleEvent(e) {
    this.set('currentMapMouseEvent', e);
  }
}
