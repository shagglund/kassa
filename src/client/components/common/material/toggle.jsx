import React from 'react';
import ImmutableComponent from '../immutable.jsx';

class Toggle extends ImmutableComponent {
  render() {
    const { label } = this.props;

    return (
      <div className='togglebutton form-control-material'>
        <input { ...this.props } onChange={this._handleInputChange.bind(this)} type='checkbox'/>
        <span className='toggle'></span>
        { label }
      </div>
    );
  }
  _handleInputChange(e) {
    const handler = this.props.onChange;

    if (handler) {
      handler(e.target.checked, e);
    }
  }
}

Toggle.propTypes = {
  checked: React.PropTypes.bool,
  label: React.PropTypes.string,
  onChange: React.PropTypes.func.isRequired,
};

export default Toggle;
