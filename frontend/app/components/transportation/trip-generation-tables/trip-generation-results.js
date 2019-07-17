import Component from '@ember/component';
import { computed } from '@ember-decorators/object';
import { getAggregatePercent } from '../../../helpers/get-aggregate-percent';
import { getAggregateValue } from '../../../helpers/get-aggregate-value';


export default class TransportationTripGenerationTablesTripGenerationResultsComponent extends Component {

  // the Transportation Analysis model belonging to the Project model
  analysis = {}
  /**
   * @param {Object[]} -- Array of modal splits
  */
  selectedCensusTractData = []
  /**
   * @param {Object} -- Hash where mode variable codes are keys and  and human readable labels are values
  */
  modeLookup = {}
  /**
   * @param {string[]} -- items must correspond to one of the variable modes defined in 
   * app/utils/VARIABLE_MODE_LOOKUP
  */
  modalSplitVariablesSubset = [];

  @computed('selectedCensusTractData', 'modalSplitVariablesSubset', 'modeLookup')
  get modeAggregatePercents() {
    let modeAggPercents = {};
    for(let mode of this.modalSplitVariablesSubset){
      modeAggPercents[mode] = getAggregatePercent([this.selectedCensusTractData, [mode], false]) / 100;
    }
    return modeAggPercents;
  }

  /** PERSON TRIPS **/

  // trip gen result for given weekday time, direction and mode
  @computed('modeAggregatePercents', 'modalSplitVariablesSubset', 'analysis.{residentialUnits,dailyTripRate.weekday.rate,temporalDistributions.decimal,inOutDists}')
  get weekdayModeCalcs(){
    let ta = this.analysis;
    let weekdayModeCalcs = {
      am: { in: {}, out: {}, },
      md: { in: {}, out: {}, },
      pm: { in: {}, out: {}, },
    };
    for(let time of ['am', 'md', 'pm']){
      for(let inOut of ['in', 'out']){
        for(let mode of this.modalSplitVariablesSubset){
          weekdayModeCalcs[time][inOut][mode] = ta.residentialUnits *
            ta.dailyTripRate.weekday.rate *
            ta.temporalDistributions[time].decimal *
            (ta.inOutDists[time][inOut] / 100) *
            this.modeAggregatePercents[mode];
        }
      }
    }
    return  weekdayModeCalcs;
  }

  // totals of trip gen results across modes for a given weekday/time/inOut
  @computed('weekdayModeCalcs', 'modalSplitVariablesSubset')
  get weekdayModesTotals() {
    let weekdayModesTotals = {
      am: { in: {}, out: {}, },
      md: { in: {}, out: {}, },
      pm: { in: {}, out: {}, },
    };
    for(let time of ['am', 'md', 'pm']){
      for(let inOut of ['in', 'out']){
        weekdayModesTotals[time][inOut] = this.modalSplitVariablesSubset.reduce(
          (acc, mode) => {
            return acc += this.weekdayModeCalcs[time][inOut][mode];
          }, 0)
      }
    }
    return weekdayModesTotals;
  }

  // per-mode weekday totals.
  // i.e. totals of trip gen results of both 'in' and 'out' directions for a given weekday time and mode
  @computed('weekdayModeCalcs', 'modalSplitVariablesSubset')
  get totalsOfWeekdayMode() {
    let totalsOfWeekdayMode = {
      am: {},
      md: {},
      pm: {},
    };
    for(let time of ['am', 'md', 'pm']){
      for(let mode of this.modalSplitVariablesSubset){
        totalsOfWeekdayMode[time][mode] = this.weekdayModeCalcs[time]['in'][mode] +
          this.weekdayModeCalcs[time]['out'][mode]
      }
    }
    return totalsOfWeekdayMode;
  }

  // total of trip gen results  across per-mode totals for a given weekday time
  @computed('totalsOfWeekdayMode', 'modalSplitVariablesSubset')
  get totalsOfTotalsOfWeekdayMode() {
    let totalsOfTotalsOfWeekdayMode = {
      am: null,
      md: null,
      pm: null,
    };
    for(let time of ['am', 'md', 'pm']){
      totalsOfTotalsOfWeekdayMode[time] = this.modalSplitVariablesSubset.reduce(
        (acc, mode) => {
          return acc += this.totalsOfWeekdayMode[time][mode];
        }, 0)
    }
    return totalsOfTotalsOfWeekdayMode;
  }

  @computed('modeAggregatePercents', 'modalSplitVariablesSubset', 'analysis.{residentialUnits,dailyTripRate.saturday.rate,temporalDistributions.decimal,inOutDists}')
  get saturdayModeCalcs() {
    let ta = this.analysis;
    let saturdayModeCalcs = {
      in: {}, out: {},
    };
    for(let inOut of ['in', 'out']){
      for(let mode of this.modalSplitVariablesSubset){
        saturdayModeCalcs[inOut][mode] = ta.residentialUnits *
            ta.dailyTripRate.saturday.rate *
            ta.temporalDistributions['saturday'].decimal *
            (ta.inOutDists['saturday'][inOut] / 100) *
            this.modeAggregatePercents[mode];
      }
    }
    return  saturdayModeCalcs;
  }

  //totals of trip gen results across modes for a given saturday time/inOut
  @computed('saturdayModeCalcs', 'modalSplitVariablesSubset')
  get saturdayModesTotals() {
    let saturdayModesTotals = {
      in: {}, out: {},
    };
    for(let inOut of ['in', 'out']){
      saturdayModesTotals[inOut] = this.modalSplitVariablesSubset.reduce(
        (acc, mode) => {
          return acc += this.saturdayModeCalcs[inOut][mode];
        }, 0)
    }
    return saturdayModesTotals;
  }

  // per-mode saturday totals.
  // i.e. total of both 'in' and 'out' directions for a given saturday and mode
  @computed('saturdayModeCalcs', 'modalSplitVariablesSubset')
  get totalsOfSaturdayMode() {
    let totalsOfSaturdayMode = {
      // keys of all modes in this.modalSplitVariablesSubset
    };
    for(let mode of this.modalSplitVariablesSubset){
      totalsOfSaturdayMode[mode] = this.saturdayModeCalcs['in'][mode] +
        this.saturdayModeCalcs['out'][mode];
    }
    return totalsOfSaturdayMode;
  }

  // total of trip gen results across per-mode totals for Saturday
  @computed('totalsOfSaturdayMode')
  get totalOfTotalsOfSaturdayMode() {
    return this.modalSplitVariablesSubset.reduce(
      (acc, mode) => {
        return acc += this.totalsOfSaturdayMode[mode];
      }, 0)
  }

  /** VEHICLE TRIPS **/

  @computed('selectedCensusTractData')
  get vehicleOccupancy() {
    return getAggregateValue([this.selectedCensusTractData, ['vehicle_occupancy']]);
  }

  @computed('weekdayModeCalcs', 'vehicleOccupancy')
  get weekdayAutoVehicleTripCalcs() {
    let weekdayAutoVehicleTripCalcs = {
      am: { in: {}, out: {}, },
      md: { in: {}, out: {}, },
      pm: { in: {}, out: {}, },
    };
    for(let time of ['am', 'md', 'pm']){
      for(let inOut of ['in', 'out']){
        if(!isNaN(this.weekdayModeCalcs[time][inOut].trans_auto_total)){
          weekdayAutoVehicleTripCalcs[time][inOut] = this.weekdayModeCalcs[time][inOut].trans_auto_total  / this.vehicleOccupancy;
        }
      }
    }
    return weekdayAutoVehicleTripCalcs;
  }

  @computed('weekdayAutoVehicleTripCalcs')
  get weekdayAutoVehicleTripTotals() {
    let weekdayAutoVehicleTripTotals = {
      am: null,
      md: null,
      pm: null,
    };
    for(let time of ['am', 'md', 'pm']){
      weekdayAutoVehicleTripTotals[time] = this.weekdayAutoVehicleTripCalcs[time]['in'] + 
      this.weekdayAutoVehicleTripCalcs[time]['out']
    }
    return weekdayAutoVehicleTripTotals;
  }

  @computed('saturdayModeCalcs', 'vehicleOccupancy')
  get saturdayAutoVehicleTripCalcs() {
    let saturdayAutoVehicleTripCalcs = {
      in: null,
      out: null,
    }
    for(let inOut of ['in', 'out']){
      if(!isNaN(this.saturdayModeCalcs[inOut].trans_auto_total)){
        saturdayAutoVehicleTripCalcs[inOut] = this.saturdayModeCalcs[inOut].trans_auto_total  / this.vehicleOccupancy;
      }
    }
    return saturdayAutoVehicleTripCalcs;
  }

  @computed('saturdayAutoVehicleTripCalcs')
  get saturdayAutoVehicleTripTotal() {
    return this.saturdayAutoVehicleTripCalcs.in + this.saturdayAutoVehicleTripCalcs.out;
  }

  @computed('weekdayModeCalcs', 'analysis.taxiVehicleOccupancy')
  get weekdayTaxiVehicleTripCalcs() {
    if(this.analysis.taxiVehicleOccupancy){
      let weekdayTaxiVehicleTripCalcs = {
        am: { in: {}, out: {}, },
        md: { in: {}, out: {}, },
        pm: { in: {}, out: {}, },
      };
      for(let time of ['am', 'md', 'pm']){
        for(let inOut of ['in', 'out']){
          if(!isNaN(this.weekdayModeCalcs[time][inOut].trans_taxi)){
            weekdayTaxiVehicleTripCalcs[time][inOut] = this.weekdayModeCalcs[time][inOut].trans_taxi  / this.analysis.taxiVehicleOccupancy;
          }
        }
      }
      return weekdayTaxiVehicleTripCalcs;
    }
    return null;
  }

  @computed('weekdayTaxiVehicleTripCalcs')
  get weekdayTaxiVehicleTripTotals() {
    if(this.analysis.taxiVehicleOccupancy){
      let weekdayTaxiVehicleTripTotals = {
        am: null,
        md: null,
        pm: null,
      };
      for(let time of ['am', 'md', 'pm']){
        weekdayTaxiVehicleTripTotals[time] = this.weekdayTaxiVehicleTripCalcs[time]['in'] + 
        this.weekdayTaxiVehicleTripCalcs[time]['out']
      }
      return weekdayTaxiVehicleTripTotals;
    }
    return null;
  }

  @computed('saturdayModeCalcs', 'analysis.taxiVehicleOccupancy')
  get saturdayTaxiVehicleTripCalcs(){
    if(this.analysis.taxiVehicleOccupancy){
      let saturdayTaxiVehicleTripCalcs = {
        in: null,
        out: null,
      }
      for(let inOut of ['in', 'out']){
        if(!isNaN(this.saturdayModeCalcs[inOut].trans_taxi)){
          saturdayTaxiVehicleTripCalcs[inOut] = this.saturdayModeCalcs[inOut].trans_taxi  / this.analysis.taxiVehicleOccupancy;
        }
      }
      return saturdayTaxiVehicleTripCalcs;
    }
    return null;
  }

  @computed('saturdayTaxiVehicleTripCalcs')
  get saturdayTaxiVehicleTripTotal() {
    if(this.analysis.taxiVehicleOccupancy){
      return this.saturdayTaxiVehicleTripCalcs.in + this.saturdayTaxiVehicleTripCalcs.out;
    }
    return null;
  }

}
