# CitadelDB

[CitadelDB](http://citadeldb.herokuapp.com) records active citadels in Eve Online and provides an API to respond with citadel data

## Installation

CitadelDB is a Sinatra app and uses ruby version 2.2.3

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
