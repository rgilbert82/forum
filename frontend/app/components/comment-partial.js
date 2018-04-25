import Ember from 'ember';

export default Ember.Component.extend({
  store: Ember.inject.service('store'),
  userSession: Ember.inject.service('user-session'),

  body: '',
  responseMessage: '',
  errorMessage: '',
  editHidden: true,
  replyHidden: true,
  fullView: true,

  currentUser: Ember.computed('userSession.currentUser', function() {
    return this.get('userSession').get('currentUser');
  }),

  currentUserOwnsTopic: Ember.computed('currentUser', 'comment', function() {
    let user = this.get('currentUser');

    if (user) {
      return this.get('comment').get('user').get('id') === user.get('id');
    } else {
      return null;
    }
  }),

  currentUserIsAdmin: Ember.computed('currentUser', function() {
    let user = this.get('currentUser');

    if (user) {
      return user.get('admin');
    } else {
      return null;
    }
  }),

  validUser: Ember.computed.or('currentUserOwnsTopic', 'currentUserIsAdmin'),

  validComment: Ember.computed('comment.editable', function() {
    return this.get('comment').get('editable');
  }),

  userCanUpdate: Ember.computed.and('validUser', 'validComment'),
  userCanReply: Ember.computed.and('currentUser', 'validComment'),
  replyAllowed: Ember.computed.and('hasReplies', 'userCanReply'),

  replies: Ember.computed('comment.replies', function() {
    return this.get('comment').get('replies');
  }),

  replyIsDisabled: Ember.computed.empty('body'),
  commentIsDisabled: Ember.computed.empty('comment.body'),

  clearMessages: Ember.computed('responseMessage', 'errorMessage', function() {
    this.set('responseMessage', '');
    this.set('errorMessage', '');
  }),

  actions: {
    createReply() {
      const body = this.get('body');
      const parent = this.get('comment');
      const topic = parent.get('topic');

      const newReply = this.get('store').createRecord('post',
        { body: body, parent: parent, topic: topic });

      this.get('clearMessages');

      newReply.save().then((response) => {
        this.get('replies').pushObject(response);
        this.set('replyHidden', true);
      }).catch((response) => {
        this.get('store').unloadRecord(newReply);
        this.set('errorMessage', 'Oops! Something went wrong!');
      });

      this.set('body', '');
    },

    editComment() {
      this.get('clearMessages');

      if (this.get('comment').get('hasDirtyAttributes')) {
        this.get('comment').save().then((response) => {
          this.set('editHidden', true);
        }).catch((response) => {
          this.get('comment').rollbackAttributes();
          this.set('errorMessage', 'Oops! Something went wrong!');
        });
      } else {
        return null;
      }
    },

    deleteComment() {
      let deletedComment = this.get('comment');

      this.get('clearMessages');

      if (confirm("Are you sure?")) {
        deletedComment.setProperties({ editable: false, body: "[ this comment has been deleted ]"});
        deletedComment.save().then((response) => {
          console.log(response);
        }).catch((response) => {
          this.get('comment').rollbackAttributes();
          this.set('errorMessage', 'Oops! Something went wrong!');
        });
      }
    },

    toggleEditView() {
      this.set('replyHidden', true);
      this.set('editHidden', !this.get('editHidden'));
      this.set('body', '');
      if (this.get('comment').get('hasDirtyAttributes')) {
        this.get('comment').rollbackAttributes();
      }
    },

    toggleReplyView() {
      this.set('editHidden', true);
      this.set('replyHidden', !this.get('replyHidden'));
      this.set('body', '');
      if (this.get('comment').get('hasDirtyAttributes')) {
        this.get('comment').rollbackAttributes();
      }
    },

    toggleFullView() {
      this.set('fullView', !this.get('fullView'));
    }
  }
});
