import { BehaviorSubject } from 'rx';
import { is } from 'immutable';
import { get, set, has } from 'lodash';

function noOpReturn(subscriber, value) {
  return value;
}

function observe(observable, subscriber, stateKey, filter) {
  observable.subscribe(newValue => {
    if (!is(newValue, subscriber.state.immutable.getIn(stateKey))) {
      subscriber.setImmutableState(prev => prev.setIn(stateKey, filter(subscriber, newValue)));
    }
  });
}

const
  observables = {},
  subscriptions = {};

class Store {
  initialize(key, defaultValue, ObservableType = BehaviorSubject) {
    if (has(observables, key)) {
      throw new Error(`Observable at ${key} is already initialized.`);
    }

    set(observables, key, new ObservableType(defaultValue));
  }
  isInitialized(key) {
    return has(observables, key);
  }
  subscribe(subscriber) {
    if (subscriptions[subscriber]) {
      this.unsubscribe(subscriber);
    }

    subscriptions[subscriber] = [];

    subscriber.constructor.subscriptions.forEach(config => {
      const { filter, stateKey, observableKey } = config;

      subscriptions[subscriber].push(observe(
        observables[observableKey],
        subscriber,
        stateKey,
        filter || noOpReturn
      ));
    });
  }
  unsubscribe(subscriber) {
    subscriptions[subscriber].forEach(subscription => {
      subscription.dispose();
    });
    delete subscriptions[subscriber];
  }
  publish(key, nextValue) {
    get(observables, key).onNext(nextValue);
  }
}

// Export global instance
export default Object.freeze(new Store());
