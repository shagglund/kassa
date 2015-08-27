import Store from '../../lib/store';
import ImmutableComponent from './immutable.jsx';


class SubscriptionComponent extends ImmutableComponent {
  componentWillMount() {
    Store.subscribe(this);
  }
  componentWillUnmount() {
    Store.unsubscribe(this);
  }
}

// defaults, override in component
SubscriptionComponent.subscriptions = [];

export default SubscriptionComponent;
