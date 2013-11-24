module Bitstampede
  class NonceGenerator
    def generate
      t = Time.now
      t.to_i.to_s + t.usec.to_s[0..1]
    end
  end
end
