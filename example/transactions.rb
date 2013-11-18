require_relative './example'

Example.new do |client|
  ap client.transactions(limit:10)
end

