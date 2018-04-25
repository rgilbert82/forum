import Ember from 'ember';

export default Ember.Controller.extend({
  userSession: Ember.inject.service('user-session'),

  editViewHidden: true,

  currentUser: Ember.computed('userSession.currentUser', function() {
    return this.get('userSession').get('currentUser');
  }),
  currentUserProfile: Ember.computed('currentUser', 'model', function() {
    let user = this.get('currentUser');

    if (user) {
      return this.get('currentUser').get('id') === this.get('model').get('id');
    } else {
      return null;
    }
  }),
  otherUserProfile: Ember.computed.not('currentUserProfile'),
  isAdmin: Ember.computed('currentUser', function() {
    let user = this.get('currentUser');

    if (user) {
      return user.get('admin');
    } else {
      return null
    }
  }),
  userCanUpdate: Ember.computed.or('currentUserProfile', 'isAdmin'),

  usernameLength: Ember.computed.gte('model.username.length', 3),
  passwordLength: Ember.computed.gte('model.password.length', 6),
  validInputs: Ember.computed.and('usernameLength', 'passwordLength'),
  isDisabled: Ember.computed.not('validInputs'),

  actions: {
    editUser() {
      if (this.get('model').get('hasDirtyAttributes')) {
        this.get('model').save().then(() => {
          this.set('editViewHidden', true);
        }).catch(() => {
          this.get('model').rollbackAttributes();
        });
      }
    },

    deleteUser() {
      if (confirm("Are you sure you want to delete your profile forever?")) {
        this.get('currentUser').destroyRecord().then(() => {
          this.get('userSession').logout();
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
