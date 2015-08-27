import React from 'react';
import { Row, Col } from 'react-bootstrap';
import { RouteHandler } from 'react-router';
import ImmutableComponent from './common/immutable.jsx';
import Navigation from './navigation.jsx';

class App extends ImmutableComponent {
  render() {
    return (
      <Col xs={12}>
        <Row>
          <Navigation />
        </Row>
        <RouteHandler {...this.props}/>
      </Col>
    );
  }
}

export default App;
