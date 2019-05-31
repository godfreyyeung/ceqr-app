import Component from '@ember/component';

export default class CensusTractSelectorComponent extends Component {
  didUpdateAttrs(){
    if(this.censusTractFeature){
      this.onselect(this.censusTractFeature);
    }
  }
}
