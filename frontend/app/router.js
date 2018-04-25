import Ember from 'ember';
import config from './config/environment';

const Router = Ember.Router.extend({
  location: config.locationType,
  rootURL: config.rootURL
});

Router.map(function() {
  this.route('user', { path: '/u/:slug' }, function() {
    this.route('upvoted', {path: '/upvoted'});
    this.route('downvoted', {path: '/downvoted'});
    this.route('submitted', {path: '/submitted'});
    this.route('saved', {path: '/saved'});
    this.route('comments', {path: '/comments'});
    this.route('contact', {path: '/contact'});
    this.route('not-found', { path: '/*path' });
  });
  this.route('forums', { path: '/' });
  this.route('topics', { path: '/f/:slug' }, function() {
    this.route('show', { path: '/comments/:topic_slug' });
    this.route('new', { path: '/new' });
    this.route('edit', { path: '/edit/:topic_slug' });
    this.route('not-found', { path: '/*path' });
  });
  this.route('register');
  this.route('mailbox', {path: '/mailbox'}, function() {
    this.route('show', {path: '/m/:conversation_slug'});
    this.route('trash');
  });

  this.route('not-found', { path: '/*path' });
});

export default Router;
