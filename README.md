# JugemKey

A simple interface for using the JugenKey Auththentication API.

## Installation

Add this line to your application's Gemfile:

    gem 'jugem_key'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install jugem_key

## Usage

    ```ruby
    require 'jugem_key'

    api = JugemKey::Auth.new {
      api_key: '...',
      secret:  '...'
    }

    # make login uri
    uri = api.uri_to_login {
      callback_url: 'http://yourapp_callback_url',
      params1:      'value1',
      params2:      'value2'
    }
    puts uri

    # exchange frob for token
    frob = params[:frob]
    user = api.token(frob) rescue "Couldn't get token" 
    user.name
    user.token

    # get user info from token
    user = api.user(token) rescue "Couldn't get user"
    user.name
    ```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
