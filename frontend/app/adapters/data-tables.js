import DS from 'ember-data';

const { JSONAPIAdapter } = DS;

export default class DataTablesAdapter extends JSONAPIAdapter {
  urlForFindRecord(id, model) {
    return `/${model}/${id}.json`;
  }
}