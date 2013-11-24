require_relative './example'
require 'awesome_print'

Example.new do |client|
  # check args
  unless ARGV[0]
    puts <<EOT
  Usage: #{$0} <price_usd>
  Ex:    #{$0} 850.00
EOT
    exit 1
  end

  # show previous
  hob = client.house_order_book
  puts Terminal::Table.new title:      "House Order Book #{hob.timestamp}",
                           headings:   ["bids@usd", "bids@btc","asks@usd","asks@btc"],
                           rows:       (0..9).map {|i| [hob.bids[i].usd.to_s('F'),hob.bids[i].btc,hob.asks[i].usd,hob.asks[i].btc]}
  Hlpr.show_dictionary_as_table(client.user_orders,"User Orders")
  Hlpr.show_dictionary_as_table(client.user_transactions,"User Transactions", 5)
  current_balance = client.user_balance
  ap current_balance

  # make buy
  puts("*"*120)
  price_usd  = BigDecimal.new(ARGV[0].to_s)
  spent_total_usd  = client.user_balance.usd_available
  spent_fee_usd    = spent_total_usd * (current_balance.fee/100)
  spent_transacted_usd = spent_total_usd - spent_fee_usd
  amount_btc = BigDecimal.new(spent_transacted_usd / price_usd)
  print("Place buy order: #{price_usd}usd/btc, -#{spent_total_usd}usd (fee #{spent_fee_usd}usd), +#{amount_btc}btc  y/[n] ?")
  if STDIN.gets.chomp.downcase != "y"
    puts "Aborting"
    exit 255
  end
  ap client.buy!(amount_btc.to_s("F"),price_usd.to_s("F"))
  puts("*"*120)

  # show posterior 
  puts "Waiting 10secs to update"
  sleep 10
  Hlpr.show_dictionary_as_table(client.user_orders,"User Orders")
  Hlpr.show_dictionary_as_table(client.user_transactions,"User Transactions", 5)
  ap client.user_balance

end
