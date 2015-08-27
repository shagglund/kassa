require('bootstrap/less/bootstrap.less');
require('bootstrap-material-design/less/material.less');
require('./styles/app.less');

import { run, HistoryLocation } from 'react-router';
import React, { render } from 'react';
import routes from './config/routes.jsx';

run(routes, HistoryLocation, (Handler, state) => {
  render(<Handler {...state}/>, document.getElementById('content'));
});
