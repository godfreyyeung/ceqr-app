import Controller from '@ember/controller';
import { inject as service } from '@ember/service';
import { computed } from '@ember-decorators/object';
import { alias } from '@ember-decorators/object/computed';

export default class ProjectShowTransportationController extends Controller {

  @alias('model.project') project;
  @alias('model.transportationAnalysis') analysis;

}
