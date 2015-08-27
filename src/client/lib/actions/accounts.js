import Store from '../store';
import CLIENT_CONFIG from '../../config/browser';
import { getJson } from '../common/http';
import { List, fromJS } from 'immutable';

const ACCOUNTS = Symbol.for('accounts');

let cachedGetAll = null;

Store.initObservable(ACCOUNTS, new List());

export function getAll(reload = false) {
  if (reload || !cachedGetAll) {
    cachedGetAll = getJson(CLIENT_CONFIG.BASE_PATH)
      .then((response)=> {
        Store.publish(ACCOUNTS, fromJS(response.users));
      })
      .catch(message=> message);
  }
  return cachedGetAll;
}
