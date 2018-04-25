import Ember from 'ember';

export default Ember.Route.extend({
  beforeModel(model) {
    this.transitionTo('forums');
  }
});
