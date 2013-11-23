require_relative './example'
require 'awesome_print'

Example.new do |client|
  ap client.orders
end
