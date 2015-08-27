import React from 'react';
import { Route, DefaultRoute, Redirect } from 'react-router';
import App from '../components/app.jsx';
import AccountIndex from '../components/accounts/index.jsx';
import EditAccount from '../components/accounts/edit.jsx';
import NewAccount from '../components/accounts/new.jsx';
import ProductIndex from '../components/products/index.jsx';
import EditProduct from '../components/products/edit.jsx';
import NewProduct from '../components/products/new.jsx';
import PurchasesIndex from '../components/purchases/index.jsx';
import SignOut from '../components/sign_out.jsx';
import ProductListing from '../components/buys/product_listing.jsx';

const routes = (
  <Route path=''>
    <Route handler={App} name='app' path='app'>
      <Route name='accounts' path='accounts'>
        <DefaultRoute handler={AccountIndex} />
        <Route handler={NewAccount} name='accounts-new' path='new' />
        <Route handler={EditAccount} name='accounts-me' path='me' />
        <Route name='accounts-detail' path=':accountId'>
          <DefaultRoute handler={EditAccount} />
          <Route handler={ProductListing} name='accounts-buy' path='buy' />
        </Route>
      </Route>
      <Route name='products' path='products'>
        <DefaultRoute handler={ProductIndex} />
        <Route handler={NewProduct} name='products-new' path='new' />
        <Route handler={EditProduct} name='products-detail' path=':productId' />
      </Route>
      <Route handler={PurchasesIndex} name='purchases' path='purchases' />
      <Route handler={SignOut} name='sign-out' path='sign-out' />
      <Redirect from='/app' to='accounts' />
    </Route>
    //TODO remove this + outer route once html5 history location works
    <Redirect from='/' to='app' />
  </Route>
);

export default routes;
