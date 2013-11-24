require_relative './example'

Example.new do |client|
  transactions = client.transactions(limit:30).reverse
  Hlpr.show_dictionary_as_table(transactions,"Client Transactions")
end

