import { get } from 'qwest';
import { Map } from 'immutable';

const defaults = new Map({
  withCredentials: true,
  headers: {
    Accept: 'application/json',
    'Content-Type': 'application/json',
  },
});

export function getJson(url, opts) {
  return get(url, null, defaults.merge(opts).toObject());
}
