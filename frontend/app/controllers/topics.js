import Ember from 'ember';

export default Ember.Controller.extend({
  userSession: Ember.inject.service('user-session'),

  editViewHidden: true,

  currentUser: Ember.computed('userSession.currentUser', function() {
    return this.get('userSession').get('currentUser');
  }),
  isAdmin: Ember.computed('currentUser', function() {
    let user = this.get('currentUser');

    if (user) {
      return user.get('admin');
    } else {
      return null
    }
  }),

  name: Ember.computed('model.name', function() {
    return this.get('model').get('name');
  }),
  isDisabled: Ember.computed.empty('name'),

  actions: {
    editForum() {
      if (this.get('model').get('hasDirtyAttributes')) {
        this.get('model').save().then(() => {
          this.set('editViewHidden', true);
        }).catch(() => {
          this.get('model').rollbackAttributes();
        });
      }
    },

    deleteForum() {
      if (confirm("Are you sure?")) {
        this.get('model').destroyRecord().then((response) => {
          this.transitionToRoute('forums');
        }).catch((response) => {
          console.log(response);
        });
      }
    },

    toggleEditView() {
      this.set('editViewHidden', !this.get('editViewHidden'));
      if (this.get('model').get('hasDirtyAttributes')) {
        this.get('model').rollbackAttributes();
      }
    }
  }
});
