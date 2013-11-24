require "awesome_print"
require_relative './example'
require 'terminal-table'

Example.new do |client|
  hob = client.house_order_book
  table = Terminal::Table.new title:      hob.timestamp,
                              headings:   ["bids@usd", "bids@btc","asks@usd","asks@btc"],
                              rows:       (0..19).map {|i| [hob.bids[i].usd.to_s('F'),hob.bids[i].btc,hob.asks[i].usd,hob.asks[i].btc]}
  puts table
end

