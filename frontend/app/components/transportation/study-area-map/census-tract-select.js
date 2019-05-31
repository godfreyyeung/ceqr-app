import Component from '@ember/component';
import { action, computed } from '@ember-decorators/object';

export default class TransportationProjectMapCensusTractSelectComponent extends Component {
  // e-mapbox-gl block param hash
  map = {};

  // added mapbox-gl layer-id for tract selection
  layerId = '';

  tranportationAnalysisModel = undefined;

  @action
  toggleCensusTract(selectedCensusTract) {
    let jtwCensusTracts = this.transportationAnalysisModel.jtwStudySelection;
    if(selectedCensusTract){
      let selectedGeoid = selectedCensusTract[0].properties.geoid;
      if( jtwCensusTracts.includes(selectedGeoid) ){
        jtwCensusTracts.popObject(selectedGeoid);
      } else {
        jtwCensusTracts.pushObject(selectedGeoid);
      }
      this.transportationAnalysisModel.save();
    }
  }

}