module Bitstampede
  class Mapper
    def initialize
    end

    def map_balance(json)
      Balance.new(Bitstampede::JSON.json_parse(json))
    end
  end

  class Balance
    def initialize
    end
  end
end
