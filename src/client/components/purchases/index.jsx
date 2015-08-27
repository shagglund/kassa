import React from 'react';
import { Row, Col } from 'react-bootstrap';
import SubscriptionComponent from '../common/subscription.jsx';

const PURCHASES = Symbol.for('purchases');

class PurchasesIndex extends SubscriptionComponent {
  constructor(props) {
    super(props);
  }
  render() {
    const state = this.state.immutable;

    return (
      <Row>
        {
          state.get(PURCHASES).map((purchase, idx) => {
            return (
              <Col key={idx} lg={2} md={3} sm={4} xs={12}>
                { JSON.stringify(purchase) }
              </Col>
            );
          })
        }
      </Row>
    );
  }
}

PurchasesIndex.subscriptions = [
  { stateKey: PURCHASES, stream: PURCHASES },
];

export default PurchasesIndex;
