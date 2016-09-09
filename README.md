# CitadelDB API

[![Build Status](https://travis-ci.org/timlkelly/citadelDB_api.svg?branch=master)](https://travis-ci.org/timlkelly/citadelDB_api)
[![Code Climate](https://codeclimate.com/github/timlkelly/citadelDB_api/badges/gpa.svg)](https://codeclimate.com/github/timlkelly/citadelDB_api)
[![Test Coverage](https://codeclimate.com/github/timlkelly/citadelDB_api/badges/coverage.svg)](https://codeclimate.com/github/timlkelly/citadelDB_api/coverage)

The backend API for [CitadelDB](http://timlkelly.github.io/citadelDB), a database of citadels in Eve Online.

[CitadelDB API](http://citadeldb.herokuapp.com) records active citadels in Eve Online and provides an API to respond with citadel data

## Installation

CitadelDB is a Sinatra app and uses ruby version 2.2.5

    1. bundle install
    2. rake db:create db:migrate db:seed
    3. rake db:test:prepare
    4. rake db:seed RACK_ENV=test

To listen to zKillboards listen service:

`rake fetch:listen`

To pull past killmails from zkillboard:

`rake fetch:pull`

## Contributing
Open a pull request and include relevant rspec tests.

## Credits
[Eve Online](http://www.eveonline.com)

[zKillboard](http://www.zkillboard.com)

## License
MIT License
