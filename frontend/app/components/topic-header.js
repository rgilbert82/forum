import Ember from 'ember';

export default Ember.Component.extend({
  store: Ember.inject.service('store'),
  userSession: Ember.inject.service('user-session'),
  currentUser: Ember.computed('userSession.currentUser', function() {
    return this.get('userSession').get('currentUser');
  }),

  currentUserIsAdmin: Ember.computed('currentUser', function() {
    if (this.get('currentUser')) {
      return this.get('currentUser').get('admin');
    } else {
      return null;
    }
  }),

  userOwnsTopic: Ember.computed('currentUser', 'topic', function() {
    if (this.get('currentUser') && this.get('topic').get('user')) {
      return this.get('topic').get('user').get('id') === this.get('currentUser').get('id');
    } else {
      return null;
    }
  }),

  userCanUpdate: Ember.computed.or('currentUserIsAdmin', 'userOwnsTopic'),

  userUpvotedTopic: Ember.computed('getVote', 'getVote.vote', function() {
    let topicVote = this.get('getVote');

    if (topicVote) {
      return !!topicVote.get('vote');
    } else {
      return null;
    }
  }),

  userDownvotedTopic: Ember.computed('getVote', 'getVote.vote', function() {
    let topicVote = this.get('getVote');

    if (topicVote) {
      return !topicVote.get('vote');
    } else {
      return null;
    }
  }),

  getSave: Ember.computed('currentUser', 'currentUser.topicSaves.@each.topic', 'topic.id', function() {
    let topicID = this.get('topic').get('id');

    if (this.get('currentUser')) {
      return this.get('currentUser').get('topicSaves').filter(function(topicSave) {
        return topicSave.get('topic').get('id') === topicID;
      }).get('firstObject');
    } else {
      return null;
    }
  }),

  getVote: Ember.computed('currentUser', 'currentUser.votes.@each.topic', 'topic.id', function() {
    let topicID = this.get('topic').get('id');

    if (this.get('currentUser')) {
      // return this.get('currentUser').get('votes').findBy('topic.id', topicID);

      return this.get('currentUser').get('votes').filter(function(vote) {
        return vote.get('topic').get('id') === topicID;
      }).get('firstObject');
    } else {
      return null;
    }
  }),

  getVoteChoice: Ember.computed('getVote', function() {
    return this.get('getVote').get('vote');
  }),

  _deleteVote: Ember.computed('getVote', 'topic', function() {
    let topicVote = this.get('getVote');
    topicVote.destroyRecord().then((response) => {
      this.get('currentUser').reload();
      this.get('topic').reload();
    }).catch((response) => {
      console.log(response);
    });
  }),

  _updateVoteUp: Ember.computed('getVote', function() {
    let topicVote = this.get('getVote');
    topicVote.set('vote', true);
    topicVote.save().catch((response) => {
      topicVote.rollbackAttributes();
      console.log(response);
    });
  }),

  _updateVoteDown: Ember.computed('getVote', function() {
    let topicVote = this.get('getVote');
    topicVote.set('vote', false);
    topicVote.save().catch((response) => {
      topicVote.rollbackAttributes();
      console.log(response);
    });
  }),

  _createUpvote: Ember.computed('store', 'topic', function() {
    let newVote = this.get('store').createRecord('vote',
      { topic: this.get('topic'), vote: true });

    newVote.save().catch((response) => {
      this.get('store').unloadRecord(newVote);
      console.log(response);
    });
  }),

  _createDownvote: Ember.computed('store', 'topic', function() {
    let newVote = this.get('store').createRecord('vote',
      { topic: this.get('topic'), vote: false });

    newVote.save().catch((response) => {
      this.get('store').unloadRecord(newVote);
      console.log(response);
    });
  }),

  actions: {
    upvote() {
      if (!this.get('currentUser')) {
        return;
      } else if (this.get('userUpvotedTopic')) {
        this.get('_deleteVote');
      } else if (this.get('userDownvotedTopic')) {
        this.get('_updateVoteUp');
      } else {
        this.get('_createUpvote');
      }
    },

    downvote() {
      if (!this.get('currentUser')) {
        return;
      } else if (this.get('userDownvotedTopic')) {
        this.get('_deleteVote');
      } else if (this.get('userUpvotedTopic')) {
        this.get('_updateVoteDown');
      } else {
        this.get('_createDownvote');
      }
    },

    createSave() {
      let newSave;

      if (!this.get('currentUser')) {
        return;
      }

      newSave = this.get('store').createRecord('topic-save',
        { topic: this.get('topic') });

      newSave.save().catch((response) => {
        this.get('store').unloadRecord(newSave);
        console.log(response);
      });
    },

    deleteSave() {
      let topicSave;

      if (!this.get('currentUser')) {
        return;
      }

      topicSave = this.get('getSave');
      topicSave.destroyRecord().then((response) => {
        this.get('currentUser').reload();
      }).catch((response) => {
        console.log(response);
      });
    }
  }
});
