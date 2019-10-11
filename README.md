# Beds24 [![Build Status](https://travis-ci.com/mihilbabin/booking_automation.svg?branch=master)](https://travis-ci.com/mihilbabin/booking_automation) [![Gem Version](https://badge.fury.io/rb/booking_automation.svg)](https://badge.fury.io/rb/booking_automation)

This is a simple wrapper of [Beds24 API](https://beds24.com/api/index.html). It allows to fetch data related to properties and bookings created and filter that data as per API docs.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'beds24'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install beds24

## Usage

To use a gem you should allow API Key through your Beds24 settings.
Wrapper needs you to supply the account API key (auth_token) set at the menu "Settings > Account"
Operations involving a specific property need to supply the property key (propKey) set at the menu "Settings > Properties > Link"

### Sample Code for JSON API

```ruby
auth_token = '<your-key>'
client = Beds24::JSONClient.new auth_token

client.get_properties # List all account properties

prop_key = '<property-key>'

client.get_property(prop_key) # Display individual property data
client.get_property(prop_key, includeRooms: true) # Pass parameters as per docs

client.get_bookings(prop_key) # Get all bookings for given property
client.get_bookings(prop_key, includeInvoice: true) # Pass parameters as per docs
```

### Sample Code for XML API

```ruby
username = '<your-username>'
password = '<your-password>'
client = Beds24::XMLClient.new username, password

client.get_properties # List all account properties

client.get_properties(propid: 123) # Display individual property data

client.get_bookings() # Get all bookings
client.get_bookings(propid: 123, datefrom: '20190101') # Pass parameters as per docs

client.modify_booking(123, guestFirstName: 'John') # Updates by id with given params
```

Data returned is already parsed in a meaningful way to plain Ruby `Hash`.
IDs and names are extracted to a top level to avoid hash keys collision.
Attributes are also preserved.

Example:

```xml
<bookings attr="test">
    <booking id="1"><!-- DATA --></booking>
    <booking id="2"><!-- DATA --></booking>
</bookings>
```

will become:

```ruby
{
    'bookings' => {
        'attr' => 'test',
        '1' => {...},
        '2' => {...}
    }
}
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/mihilbabin/beds24.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
