import React from 'react';
import ImmutableComponent from '../immutable.jsx';
import { isEmpty } from 'lodash';

const
  ERROR = 'error',
  FOCUS = 'focus',
  SUCCESS = 'success',
  WARNING = 'warning';

class Input extends ImmutableComponent {
  getDefaultProps() {
    return {
      className: '',
      float: false,
    };
  }
  render() {
    const { placeholder, float } = this.props;

    return (
      <div className={this.getContextClassNames()}>
        { this._renderLabel() }
        <input
          { ...this.props }
          className={ this._getClassName() }
          onBlur={ this._handleFocusChange.bind(this, false) }
          onChange={ this._handleInputChange.bind(this) }
          onFocus={ this._handleFocusChange.bind(this, true) }
          placeholder={ float ? null : placeholder }/>
        { this._renderFloatingLabel() }
        <span className='material-input'></span>
        { this._renderHint() }
      </div>
    );
  }
  _renderLabel() {
    const { label, float } = this.props;

    return label && !float ? (<label>{ label }</label>) : null;
  }
  _renderFloatingLabel() {
    return this.props.float ? (<div className='floating-label'>{ this.props.placeholder }</div>) : null;
  }
  _renderHint() {
    const { hint } = this.props;

    return hint ? (<div className='hint'>{ hint }</div>) : null;
  }
  _handleInputChange(e) {
    const handler = this.props.onChange;

    if (handler) {
      handler(e.target.value, e);
    }
  }
  _handleFloatingChange(isFocused) {
    this.setImmutableState((state)=> state.set(FOCUS, isFocused && this.props.float));
  }
  _getContextClassNames() {
    return `form-control-wrapper ${this.props.status ? ('has-' + this.props.status) : ''}`;
  }
  _getClassName() {
    return `form-control
      ${this.props.float ? 'form-control-material' : null }
      ${this._isInFloatingState() ? '' : 'empty' }
      ${this.props.className}`;
  }
  _isInFloatingState() {
    return this.props.float && (this.state.immutable.get(FOCUS) || this._hasValue());
  }
  _hasValue() {
    return !isEmpty(this.props.value);
  }
}

Input.propTypes = {
  className: React.PropTypes.string,
  float: React.PropTypes.bool,
  hint: React.PropTypes.string,
  label: React.PropTypes.string,
  onChange: React.PropTypes.func.isRequired,
  placeholder: React.PropTypes.string,
  status: React.PropTypes.oneOf([ WARNING, ERROR, SUCCESS ]),
  value: React.PropTypes.oneOfType([
    React.PropTypes.string,
    React.PropTypes.number,
    React.PropTypes.bool,
  ]),
};

export default Input;
