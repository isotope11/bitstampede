require_relative './example'

Example.new do |client|
  bal = client.balance
  "".tap do |output|
    bal.class.keys.each do |key|
      output << "#{key}: #{bal.send(key).to_digits}\n"
    end
  end
end
