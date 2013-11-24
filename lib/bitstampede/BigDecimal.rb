require 'bigdecimal'

class BigDecimal
  alias_method :original_to_s, :to_s
  # Example:
  #   BigDecimal.new("3.141516").to_s     # => "3.141516"
  #   BigDecimal.new("3.141516").to_s(3)  # => "3.142"   ( rounded into 3 signif digits )
  def to_s(num_signif_digits=nil)
    case 
    when num_signif_digits.is_a?(Integer) 
      return self.round(num_signif_digits).original_to_s("F")
    else
      result = ( num_signif_digits ? self.original_to_s(num_signif_digits) : self.original_to_s("F") )
      return result
    end
  end
end

