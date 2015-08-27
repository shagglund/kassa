import React from 'react';
import ImmutableComponent from '../immutable.jsx';

class Icon extends ImmutableComponent {
  shouldComponentUpdate(nextProps) {
    return this.props !== nextProps;
  }
  render() {
    const { icon, flip, className } = this.props,
      computedClassName = `${className} mdi-${icon} ${flip ? 'flipped-image' : ''}`;

    return (
      <span className={ computedClassName }></span>
    );
  }
}

Icon.propTypes = {
  className: React.PropTypes.string,
  flip: React.PropTypes.bool,
  icon: React.PropTypes.string.isRequired,
};

export default Icon;
