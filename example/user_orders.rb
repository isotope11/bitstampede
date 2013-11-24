require_relative './example'
require 'awesome_print'

Example.new do |client|
  ords = client.orders
  Hlpr.show_dictionary_as_table(ords,"User Orders")
end
