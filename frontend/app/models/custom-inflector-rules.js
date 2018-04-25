import Inflector from 'ember-inflector';

const inflector = Inflector.inflector;

inflector.irregular('topic-save', 'topic-saves');

// Meet Ember Inspector's expectation of an export
export default {};
