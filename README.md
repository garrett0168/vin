# VIN Decoder Web App

This is a simple app for decoding VINs and viewing information about the vehicle's make, model, etc... You can also view a list of all historical VIN lookups.

Prerequisites
=============

* ruby 1.9.3
* PostgreSQL

For testing:

* [PhantomJS (1.9.0 or above)](http://phantomjs.org/download.html) Extract and put bin/phantomjs in your path.
* [Karma](http://karma-runner.github.io)

Edmunds API
===========

Sign up for a key: http://developer.edmunds.com/

Set the key in the `EDMUNDS_API_KEY` environment variable. You can set it in your `.bashrc` file or set it when you startup rails, e.g. `EDMUNDS_API_KEY=123 bundle exec rails server`

Setup
=====

1. `bundle install`
2. `bundle exec rake db:create`
3. `bundle exec rake db:migrate`

Running Tests
=============

Rspec tests:

`bundle exec rspec`

Cucumber tests:

`bundle exec cucumber`

Javascript tests:

`karma start spec/karma/config/dev.js`

Starting the server
===================

`bundle exec rails server`
