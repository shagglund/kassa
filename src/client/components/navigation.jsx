import React from 'react';
import { Navbar, Nav, NavItem } from 'react-bootstrap';
import { fromJS } from 'immutable';
import ImmutableComponent from './common/immutable.jsx';
import Icon from './common/material/icon.jsx';

const
  KASSA_TITLE = 'Kassa',
  NAVIGATION_ITEMS = fromJS({
    accounts: 'Accounts',
    products: 'Products',
    purchases: 'Purchases',
  }),
  RIGHT_NAVIGATION_ITEMS = fromJS({
    'accounts-me': 'action-account-circle',
    'sign-out': 'action-exit-to-app',
  });

class Navigation extends ImmutableComponent {
  render() {
    const { router } = this.context;

    return (
      <Navbar brand={ KASSA_TITLE } fluid>
        <Nav>
        {
          NAVIGATION_ITEMS.map((title, pathKey)=>
            (
              <NavItem
                eventKey={ pathKey }
                href={ router.makeHref(pathKey) }
                key={ pathKey }>
                { title }
              </NavItem>
            )
          )
        }
        </Nav>
        <Nav right>
        {
          RIGHT_NAVIGATION_ITEMS.map((icon, pathKey)=>
            (
              <NavItem
                eventKey={ pathKey }
                href={ router.makeHref(pathKey) }
                key={ pathKey }>
                <Icon icon={ icon }/>
              </NavItem>
            )
          )
        }
        </Nav>
      </Navbar>
    );
  }
}

Navigation.contextTypes = {
  router: React.PropTypes.func.isRequired,
};

export default Navigation;
