import Globalize from 'globalize';

Globalize.load(
  require('cldr-data/main/en/ca-gregorian'),
  require('cldr-data/main/en/currencies'),
  require('cldr-data/main/en/dateFields'),
  require('cldr-data/main/en/numbers'),
  require('cldr-data/main/fi/ca-gregorian'),
  require('cldr-data/main/fi/currencies'),
  require('cldr-data/main/fi/dateFields'),
  require('cldr-data/main/fi/numbers'),
  require('cldr-data/supplemental/currencyData'),
  require('cldr-data/supplemental/likelySubtags'),
  require('cldr-data/supplemental/plurals'),
  require('cldr-data/supplemental/timeData'),
  require('cldr-data/supplemental/weekData')
);

Globalize.loadMessages(require('./messages/en'));
Globalize.loadMessages(require('./messages/fi'));

// Set 'en' as our default locale.
Globalize.locale('en');

export default Globalize;
