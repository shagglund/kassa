import React from 'react';
import { Link } from 'react-router';
import { Well, Row, Col } from 'react-bootstrap';
import { Map } from 'immutable';
import SubscriptionComponent from '../common/subscription.jsx';
import Icon from '../common/material/icon.jsx';
import Gravatar from '../common/gravatar.jsx';

const SHOW_EDIT_ICON = 'showEditIcon';


class AccountCard extends SubscriptionComponent {
  constructor(props) {
    super(props);
    this.setInitialImmutableState({ [SHOW_EDIT_ICON]: false });
  }
  render() {
    const { account } = this.props,
      showEditIcon = this.state.immutable.get(SHOW_EDIT_ICON);

    return (
      <Col md={2} sm={3} xs={6}>
        <Well bsSize='small'
          className='clickable top-corner-icon-container'
          onMouseEnter={this._showEditIcon.bind(this)}
          onMouseLeave={this._hideEditIcon.bind(this)}>
          <Link params={{ accountId: account.get('id') }} to='accounts-buy'>
            <Row>
              <Col className=' text-center' xs={12}>
                <Gravatar
                  className='img-circle'
                  email={ account.get('email')}
                  size={96} />
              </Col>
            </Row>
            <Row>
              <Col className='text-center' xs={12}>
                <a className=' text-primary'>{ account.get('username') }</a>
              </Col>
            </Row>
            <Row>
            <hr/>
            </Row>
            <Row className='text-primary'>
              <Col className='text-center' xs={3}>
                <Icon icon='action-shopping-cart' />
              </Col>
              <Col xs={9}>
                <p>{ account.get('buyCount') }</p>
              </Col>
            </Row>
            <Row className={account.get('balance') > 0 ? 'text-success' : 'text-danger'}>
              <Col className='text-center' xs={3}>
                <Icon icon='action-account-balance-wallet' />
              </Col>
              <Col xs={9}>
                <p>{ account.get('balance') }&nbsp;€</p>
              </Col>
            </Row>
          </Link>
          {
            showEditIcon ? (<div className='top-corner-icon'>
                <Link params={{ accountId: account.get('id') }} to='accounts-detail'>
                  <Icon icon='editor-mode-edit' />
                </Link>
              </div>) : null
          }
        </Well>
      </Col>
    );
  }
  _showEditIcon() {
    this.setImmutableState((state)=> state.set(SHOW_EDIT_ICON, true));
  }
  _hideEditIcon() {
    this.setImmutableState((state)=> state.set(SHOW_EDIT_ICON, false));
  }
}

AccountCard.propTypes = {
  account: React.PropTypes.instanceOf(Map).isRequired,
};

export default AccountCard;
