import React from 'react';
import { Panel, ListGroup, ListGroupItem, Row, Col } from 'react-bootstrap';
import SubscriptionComponent from '../common/subscription.jsx';
import Input from '../common/material/input.jsx';
import Toggle from '../common/material/toggle.jsx';

const ACCOUNT = Symbol.for('account'),
  ACCOUNTS = Symbol.for('accounts'),
  ACTIVE = 'active',
  EMAIL = 'email',
  USERNAME = 'username';

class EditAccount extends SubscriptionComponent {
  render() {
    const account = this.state.immutable.get(ACCOUNT),
      active = account.get(ACTIVE),
      email = account.get(EMAIL),
      username = account.get(USERNAME);

    return (
      <Row>
        <Col sm={8} smOffset={2} xs={12}>
          <Panel header='Edit Account'>
            <ListGroup>
              <ListGroupItem>
                <Input
                  float
                  onChange={ this._handleInputChange.bind(this, USERNAME) }
                  placeholder='Account username'
                  type='text'
                  value={ username }/>
              </ListGroupItem>
              <ListGroupItem>
                <Input
                  float
                  onChange={ this._handleInputChange.bind(this, EMAIL) }
                  placeholder='Account holder email'
                  status='warning'
                  type='email'
                  value={ email } />
              </ListGroupItem>
              <ListGroupItem>
                <Toggle
                  checked={ active }
                  label='Show account in buyers'
                  onChange={ this._handleInputChange.bind(this, ACTIVE) } />
              </ListGroupItem>
            </ListGroup>
          </Panel>
        </Col>
        <Col sm={8} smOffset={2} xs={12}>
          <Panel header='Balance Changes' />
        </Col>
      </Row>
    );
  }
  _handleInputChange(field, value) {
    this.setImmutableState((state)=> state.set(ACCOUNT, state.get(ACCOUNT).set(field, value)));
  }
}

EditAccount.propTypes = {
  params: React.PropTypes.shape({
    accountId: React.PropTypes.number.isRequired,
  }).isRequired,
};

EditAccount.subscriptions = [
  {
    stateKey: ACCOUNT,
    stream: ACCOUNTS,
    filter(component, accounts) {
      return accounts.find(value => value.get('id') === component.props.params.accountId);
    },
  },
];

export default EditAccount;
