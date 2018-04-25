import DS from 'ember-data';

export default DS.Model.extend({
  body: DS.attr('string'),
  unread: DS.attr('boolean'),
  createdAt: DS.attr('string'),

  user: DS.belongsTo('user'),
  conversation: DS.belongsTo('conversation'),

  userSession: Ember.inject.service('user-session'),
  currentUser: Ember.computed('userSession.currentUser', function() {
    return this.get('userSession').get('currentUser');
  }),

  belongsToCurrentUser: Ember.computed('currentUser', 'currentUser.id', 'user.id', function() {
    let user = this.get('currentUser');

    if (user) {
      return user.get('id') === this.get('user').get('id');
    } else {
      return null;
    }
  }),

  datetime: Ember.inject.service('format-datetime'),

  formattedDateTime: Ember.computed('createdAt', 'datetime.format', function() {
    return this.get('datetime').format(this.get('createdAt'));
  })
});
