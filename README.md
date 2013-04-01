Kassa
=====

What is it?
----------
Kassa is a simple application for our apartment community to manage common goods (ie. "vitamin cabinet = beers"). 

At this point it mainly allows adding new simple items that can be added to a users tab, managing the tabs balance 
(each user can manage their own tab, admins can manage everyone) based on trust and purchasing items to the given user.

Why such a project?
---------------------
Mainly this has been developed to replace lists kept on paper that are easily lost. It's also a fun project to sink my teeth
into, to play with different technologies and learn! Plenty of things still to do.

How to install it?
-----------------
1) By default the application uses PostgreSQL as the database with password (md5)-based authentication 
(check the database.yml file under config for the default configuration or change it according to your needs). Remove the password
if you're running the database with trust-based authentication. Other ActiveRecord supported databases should be quite 
straightforward to use also.

2) Install ruby (tested with 1.9.3/2.0.0), easiest installed using rvm.
3) Install Rails (if not already installed) by running: gem install rails
4) If Bundler is missing run: gem install bundler
5) Run bundle install to install all dependent gems.
6) Create the database structure by running: bundle exec rake db:setup

6) That's it! You're now done and should test everything works in development mode by running: bundle exec rails server

7) Optionally to run all the backend automated tests you can do: bundle exec rspec (in project root)

Deploying to production
-----------------------
The development mode has been set up to work well with guard & spork which also means there are plenty of unnecessary class loading,
    assets are being compiled every time and what not.

Setup nginx for unicorn, pretty good tutorials available. Example configuration TODO.

1)To precompile the assets for production run: bundle exec rake assets:precompile
2) copy the generated files from public/ to the web servers static files root (the root specified in nginx conf)
3) run bundle exec rails server -e production to run the unicorn server in production mode

Contributing
------------
Hack it, whack it, send a pull request, open discussions, have fun with it! Everything is encouraged. There is still lots to be done,
some sort of TODO will probably follow once our community gets together and does some brainstorming (and my studies/other work don't get in the way!)

LICENSE
-------
License (MIT)
Copyright (c) 2013, Sten Hägglund

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

