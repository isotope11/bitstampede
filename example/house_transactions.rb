require "awesome_print"
require_relative './example'
require 'terminal-table'



Example.new do |client|
  hts = client.house_transactions
  Hlpr.show_dictionary_as_table(hts,"House Transactions",30)
end


