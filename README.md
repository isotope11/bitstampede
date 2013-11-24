# Bitstampede
[![Build Status](https://travis-ci.org/isotope11/bitstampede.png?branch=master)](https://travis-ci.org/isotope11/bitstampede) [![Coverage Status](https://coveralls.io/repos/isotope11/bitstampede/badge.png?branch=master)](https://coveralls.io/r/isotope11/bitstampede?branch=master) [![Code Climate](https://codeclimate.com/github/isotope11/bitstampede.png)](https://codeclimate.com/github/isotope11/bitstampede)


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

![Legitimate Concern](./old_crazy_docs/legitimate_concern.png)

Second, stop writing api clients that are configured with class ivars ಠ_ಠ

Third, this stuff:

## Actual Usage Without Silly Pictures

```ruby
client = Bitstampede::Client.new

client.key = 'YOUR_API_KEY'
client.secret = 'YOUR_API_SECRET'
client.client_id = 'YOUR_CLIENT_ID'

# Alternatively, you can configure the client on initialization with:
client = Bitstampede::Client.new(key: 'YOUR_API_KEY', secret: 'YOUR_API_SECRET', client_id: 'YOUR_CLIENT_ID')

# Fetch your balance
client.balance
# => #<Bitstampede::Entities::Balance:0x0000000259f338 @usd_balance=#<BigDecimal:259e898,'0.0',9(9)>, @btc_balance=#<BigDecimal:2726698,'0.0',9(9)>, @usd_reserved=#<BigDecimal:2726328,'0.0',9(9)>, @btc_reserved=#<BigDecimal:2725fb8,'0.0',9(9)>, @usd_available=#<BigDecimal:2725c48,'0.0',9(9)>, @btc_available=#<BigDecimal:27258b0,'0.0',9(9)>, @fee=#<BigDecimal:2725540,'0.0',9(9)>>

client.orders
#=> [
  #<Bitstampede::Entities::Order:0x000000027302d8 @id=0, @datetime=0, @type=:buy, @price=#<BigDecimal:272f428,'0.0',9(9)>, @amount=#<BigDecimal:272f130,'0.0',9(9)>>
]

# Place a limit order to buy one bitcoin for $100.00 USD
client.buy!(BigDecimal('1'), BigDecimal('100'))

# Place a limit order to sell one bitcoin for $101.00 USD
client.sell!(BigDecimal('1'), BigDecimal('101'))

# Cancel order #1234
client.cancel 1234
```

## Examples

You can run any of the examples in the `example` dir by just executing the script (except `example/example.rb`, which is the base example class).  For instance, to see your balance, do the following:

```ruby
ruby example/balance.rb
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

## License

This software is licensed under [the MIT License.](./LICENSE.md)

## Contributors

These people have contributed to the gem.  Many thanks!:

- Josh Adams
- [Robert Jackson](https://github.com/rjackson)
- [Seth Messer](https://github.com/megalithic)
- [James Cook](https://github.com/jamescook)
- [Paulo Aleixo, zipizap](https://github.com/zipizap)
