import { BehaviorSubject } from 'rx';
import { get } from 'qwest';
import { fromJS, List } from 'immutable';

const ID = 'id';

function getJson(url) {
  return get(url, null, {
    withCredentials: true,
    headers: {
      Accept: 'application/json',
      'Content-Type': 'application/json'
    }
  });
}

/*
 Common use cases for restful objects
 Expectations:
  - method responseHandler(response) to handle any transformations to be done to the response before broadcasting
*/
class RestWrapper {
  constructor(basePath) {
    this.basePath = 'http://127.0.0.1:3000' + (basePath.charAt(0) === '/' ? basePath : '/' + basePath);
  }
  getAll(reload = false) {
    if (!this._all || reload) {
      this._all = this._all || new BehaviorSubject(new List());
      getJson(this.basePath)
        .then( (response)=> {
          this._all.onNext(fromJS(this.responseHandler(response)));
        })
        .catch((message, url)=> {
          let tmp = this._all;
          this._all = new BehaviorSubject(new List());
          tmp.onError({ message, url });
        });
    }
    return this._all;
  }
  get(accountId, reload = false) {
    return this
      .getAll(reload)
      .flatMap((accounts)=> accounts )
      .filter((account)=> account.get(ID) === accountId)
      .take(1);
  }
}

export default RestWrapper;
