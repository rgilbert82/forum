import DS from 'ember-data';

export default DS.Model.extend({
  vote: DS.attr('boolean'),

  user: DS.belongsTo('user'),
  topic: DS.belongsTo('topic')
});
