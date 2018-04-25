import Ember from 'ember';

export default Ember.Service.extend({
  format(dt) {
    if (dt) {
      let timestamp = dt.split('-');
      let year = timestamp[0];
      let month = timestamp[1];
      let day = timestamp[2].split('T')[0];
      let time = timestamp[2].split('T')[1].match(/^\d+:\d+/)[0];

      return `${month}-${day}-${year} at ${time}`;
    } else {
      return null;
    }
  }
});
