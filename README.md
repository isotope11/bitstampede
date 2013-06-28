# Bitstampede
[![Build Status](https://travis-ci.org/isotope11/bitstampede.png?branch=master)](https://travis-ci.org/isotope11/bitstampede)

Bitstampede is a gem for accessing the Bitstamp API

## Installation

Add this line to your application's Gemfile:

    gem 'bitstampede'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install bitstampede

## Usage

First, look at this picture:

![Legitimate Concern](./doc/legitimate_concern.png)

Second, stop writing api clients that are configured with class ivars ಠ_ಠ

Third, this stuff:

## Actual Usage Without Silly Pictures

```ruby
client = Bitstampede::Client.new

# I am sad for the following, but such is Bitstamp at present :-\
client.key = 'YOUR_USER_ID'
client.secret = 'YOUR_PASSWORD'

# Fetch your balance
client.balance
# => What does this look like?

client.orders
#=> [
  { lol: 'not yet' }
]

# Place a limit order to buy one bitcoin for $100.00 USD
client.buy!(BigDecimal('1'), BigDecimal('100'))

# Place a limit order to sell one bitcoin for $101.00 USD
client.sell!(BigDecimal('1'), BigDecimal('101'))

# Cancel order #1234
client.cancel 1234
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

## License

This software is licensed under [the MIT License.](./LICENSE.md)
