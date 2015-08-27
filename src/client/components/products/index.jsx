import React from 'react';
import { Row, Panel, Table } from 'react-bootstrap';
import ImmutableComponent from '../common/immutable.jsx';
import SubscriptionComponent from '../common/subscription.jsx';

const PRODUCTS = Symbol.for('products');

class ProductRow extends ImmutableComponent{

}

class ProductIndex extends SubscriptionComponent {
  componentWillMount() {
    super();
  }
  render() {
    const state = this.state.immutable;

    return (
      <Row>
        <Panel>
          <Table fill hover striped>
            <thead>
              <tr>
                <th></th>
              </tr>
            </thead>
            <tbody>
              {
                state.get(PRODUCTS).map(product => (
                  <ProductRow
                    key={product.get('id')}
                    product={product} />
                ))
              }
            </tbody>
          </Table>
        </Panel>
      </Row>
    );
  }
}

ProductIndex.subscriptions = [
  { stateKey: PRODUCTS, stream: PRODUCTS },
];

export default ProductIndex;
