require "awesome_print"
require_relative './example'

Example.new do |client|
  ap client.balance
end
