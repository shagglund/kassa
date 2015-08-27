import React from 'react';
import { Map, fromJS } from 'immutable';
import { isFunction } from 'lodash';

function updateImmutableState(currentImmutableState, updateFuncOrObj) {
  let result;

  if (isFunction(updateFuncOrObj)) {
    result = updateFuncOrObj(currentImmutableState);
  } else {
    result = currentImmutableState.mergeDeep(currentImmutableState, fromJS(updateFuncOrObj));
  }
  return result;
}

class ImmutableComponent extends React.Component {
  constructor(props) {
    super(props);
    this.state = {
      immutable: new Map(),
    };
  }
  shouldComponentUpdate(nextProps, nextState) {
    return this.props !== nextProps || this.state.immutable !== nextState.immutable;
  }
  setInitialImmutableState(updateFuncOrObj) {
    this.state.immutable = updateImmutableState(this.state.immutable, updateFuncOrObj);
  }

  // this is different from React setState as it always expects a function
  // which is passed the old immutable state to be updated and expects
  // the new immutable state to be returned which has the benefit of
  // yielding much cleaner and concise code
  setImmutableState(updateFuncOrObj) {
    this.setState((prev) => {
      prev.immutable = updateImmutableState(prev.immutable, updateFuncOrObj);
    });
  }
}

export default ImmutableComponent;
