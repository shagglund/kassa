import React from 'react';
import md5 from 'blueimp-md5';

class GravatarComponent extends React.Component {
  getDefaultProps() {
    return {
      size: 32,
      rating: 'g',
      missing: 'mm',
    };
  }
  render() {
    const { email, size, } = this.props;

    return (
      <img
        {...this.props}
        alt={email}
        height={size}
        src={this._getGravatarUrl()}
        width={size} />
    );
  }
  _getGravatarUrl() {
    const { size, email, rating, https, missing } = this.props,
      base = `${https ? 'https://secure' : 'http://www'}.gravatar.com/avatar/`;

    return `${base}${md5(email)}?s=${size}&r=${rating}&d=${missing}`;
  }
}

GravatarComponent.propTypes = {
  className: React.PropTypes.string,
  default: React.PropTypes.string,
  email: React.PropTypes.string.isRequired,
  https: React.PropTypes.bool,
  missing: React.PropTypes.string,
  rating: React.PropTypes.string,
  size: React.PropTypes.number,
};

export default GravatarComponent;
