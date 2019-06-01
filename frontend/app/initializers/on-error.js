import { on } from 'rsvp';
import Ember from 'ember';

export function initialize() {
  Ember.onerror = function(err) {
    throw new Error(err);
  };
  on('error', function(err) {
    throw new Error(err);
  });
}

export default {
  initialize
};
