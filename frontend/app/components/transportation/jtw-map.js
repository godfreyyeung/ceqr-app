import Component from '@ember/component';
import { computed, action } from '@ember-decorators/object';

export default class TransportationJtwMapComponent extends Component {
    /**
   * The transportation-analysis Model, passed down from the project/show/transportation-analysis controller
   */
  analysis = {};

    /**
   * The highlighted features, already determined during previous "study area" step:
   * - user-selected study selection features
   * - required study selection features
   * which are passed to the highlight layer's FeatureFilterer
   */
  @computed('analysis.{jtwStudySelection.[],requiredJtwStudySelection.[]}')
  get highlightedFeatureIds() {
    const selectedFeatures = this.get('analysis.jtwStudySelection') || [];
    const requiredSelectedFeatures = this.get('analysis.requiredJtwStudySelection') || [];

    return [...selectedFeatures, ...requiredSelectedFeatures];
  }
}