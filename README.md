# Kassa
[![Dependency Status](https://gemnasium.com/flipflops/kassa.svg)](https://gemnasium.com/flipflops/kassa)
[![Code Climate](https://codeclimate.com/github/flipflops/kassa.png)](https://codeclimate.com/github/flipflops/kassa)
[![Build Status](https://travis-ci.org/flipflops/kassa.svg)](https://travis-ci.org/flipflops/kassa)

## Motivation
Before this project v1 was done all tab-keeping were done on paperlists. These lists were easily misplaced, full and/or unreadable. They were also always behind, one could not see his/her current balance easily at any moment. Thus Kassa was born, it's main goal is to make it easier to keep up-to-date tabs and eventually allow easier messaging for paying those tabs (i.e. email straight from kassa) and to provide historical data/trends for fun.

It's also built to facilitate my learning and for some codefun.

## Deployment

### Prerequisites
* ruby 2.1.0 with rails and bundler installed
* working and running PostgreSQL (tests are currently run against v9.3 in [Travis build](https://travis-ci.org/flipflops/kassa))
* a postgres user configured and set in secrets.yml (see next section)

#### config/secrets.yml
All sensitive information (keys, db user/password etc.) is extracted to a secrets.yml configuration file. This file needs to be present before you can launch the rails server.
Example configuration is provided at [secrets.yml.example](https://github.com/flipflops/kassa/blob/master/config/secrets.yml.example).

### Rails setup
This is a very basic rails project, following steps should get you started in development mode. Run `rake [command] RAILS_ENV=production` when deploying to production.
* Install required gems using bundler: `bundle install`
* Create required database(s): `rake db:setup`
* Run all migrations: `rake db:migrate`

#### Production only
In production you will also need to minify and compile assets: `rake assets:precompile` and serve static files from `/public` to prevent "asset not precompiled"-errors.

## Testing
All tests are located under the spec/-folder.

The rails backend is tested using [rspec](https://github.com/rspec/rspec) for both unit and request level specs.
Execute `bundle exec rspec` to run backend specs (expects test database to be set and fully migrated).

The client is tested using [Jasmine](http://jasmine.github.io/) and ran with [Teaspoon](https://github.com/modeset/teaspoon).
Execute `bundle exec teaspoon` to run client tests. (Currently WIP so not full coverage)

For continuously running tests on file changes when developing, a [Guard](https://github.com/guard/guard) setup is also provided.


## License

Copyright (c) 2012-2014 Sten Hägglund. See the [LICENSE](https://github.com/flipflops/kassa/blob/master/LICENSE) file for license rights and
limitations (MIT).
