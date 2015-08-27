import Store from '../store';
import { getJson } from '../common/http';
import { List, fromJS } from 'immutable';

const PURCHASES = Symbol.for('purchases');

Store.initObservable(PURCHASES, new List());

export function getAll() {
  getJson(this.basePath)
    .then((response)=> {
      Store.publish(PURCHASES, fromJS(response.buys));
    })
    .catch(message=> message);
}
