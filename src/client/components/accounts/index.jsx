import React from 'react';
import { Row } from 'react-bootstrap';
import SubscriptionComponent from '../common/subscription.jsx';
import AccountCard from './card.jsx';
import { getAll } from '../../lib/actions/accounts';

const ACCOUNTS = Symbol.for('accounts'),
  SORT_BY = Symbol.for('sortBy');

class AccountIndex extends SubscriptionComponent {
  constructor(props) {
    super(props);
    this.setInitialImmutableState({ [SORT_BY]: 'username' });
  }
  componentWillMount() {
    getAll();
  }
  render() {
    const accounts = this.state.immutable.get(ACCOUNTS),
      sortByField = this.state.immutable.get(SORT_BY);

    return (
      <Row>
        {
          accounts
            .sortBy(acc => acc.get(sortByField))
            .map((account, idx) => (
              <AccountCard
                account={account}
                key={idx}
              />
            ))
        }
      </Row>
    );
  }
  _sort(field) {
    this.setImmutableState((state)=> state.set(SORT_BY, field));
  }
}

AccountIndex.subscriptions = [
  { stateKey: ACCOUNTS, stream: ACCOUNTS },
];

export default AccountIndex;
