# Minly-gem [![Code Climate](https://codeclimate.com/github/andela-ooranagwa/minly-gem/badges/gpa.svg)](https://codeclimate.com/github/andela-ooranagwa/minly-gem)

Minly-gem provides access to all features of the [_Minly URL shortening service_](http://github.com/andela-ooranagwa/minly) by integrating the Minly API. With the gem, you can effortlessly create and expand minlys; have access to the most popular minlys ever create and also the recent additions to the Minly database. Even features such as deleting, deactivating and editing minlys that are reserved for registered users of the Minly service can also be accessed using a valid token.

## Dependencies
You need to have Ruby set up on you machine. The gem is built using Ruby version _2.1.7_. Also, you need to have _bundler_ installed (especially if you are including the gem in another app or project).

## Installation
Add this line to your application's Gemfile
```ruby
gem 'minly'
```
And then execute
```ruby
    $ bundle
```
Or install it yourself as
```ruby
    $ gem install minly
```

## Usage
To starting using minly, you need to require it. Do:
```ruby
    $ require 'minly'
```
Or add to your code

Next you create an instance of the minly gem:
```ruby
    $ minly = Minly::Url.new
```
Optionally, you can also instantiate with a valid token i.e

```ruby
    $ minly = Minly::Url.new(_your_valid_token_)
```
You can always do:
```ruby
$ minly.token #=> to view your token (it returns nil if token is not available)
$ minly.token = _token_ #=> to set your token
```
### Without token
```ruby
    # To get the details including the orignal url of a minly:
    $ minly.expand_minly(_xxx_) #=> (requires a valid minly as argument) returns all the details of the given minly: xxx. Returns an empty hash if the details of the given minly is not found.
```
```ruby
    # To get the most popular minlys
    $ minly.popular_minlys #=> returns an array containing the five most popular minlys.
```
```ruby
    # To get the recent minlys
    $ minly.recent_minlys #=> returns an array containing the five recent minlys.
```

### With a _valid_ token
  In addition to the above methods
```ruby
    # To create a customized minly
    $ minly.create_minly(_original-url_, _vanity-string_) #=> (original-url should be a valid url, vanity-string should be any alphanumeric character(s)) returns details of the created minly.

```
```ruby
    # To change the url target of a minly
    $ minly.change_minly_target(_xxx_, _new-origin_) #=> (xxx is a valid minly, new-origin is the new origin to assign to xxx) returns the updated minly information
```
```ruby
    # To deactivate or activate a minly
    $ minly.change_minly_status(_xxx_, _new-status_) #=> (xxx is a valid minly, new-status is the status (true or false) to assign to xxx) returns the updated minly information
```
```ruby
    # To change minly target and status at once
    $ minly.update_minly (_xxx_, _new-origin_, _new-status_) #=> (xxx is a valid minly, new-origin is the new origin to assign to xxx, new-status is the status (true or false) to assign to xxx)
```
```ruby
    # To delete a minly
    $ minly.destroy_minly(_xxx_) #=> (xxx is a valid minly) returns the information of the deleted minly
```

The response of every Minly request is parsed into two: _request status_ and _request response_

```ruby
    $ minly.status #=> [request-type, request-info]
    $ minly.status["type"] #=> success or error
    $ minly.status["info"] #=> more information about the request
```
```ruby
    $ minly.response #=> response of the api call
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/andela-ooranagwa/minly. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](contributor-covenant.org) code of conduct.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
