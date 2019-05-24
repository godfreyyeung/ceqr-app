import DS from 'ember-data';

import ENV from 'labs-ceqr/config/environment';

const { JSONAPIAdapter } = DS;

export default class CeqrManualAdapter extends JSONAPIAdapter {
  host = ENV.host;

  urlForFindRecord(id, model) {
    return `/${model}/${id}.json`;
  }
}
