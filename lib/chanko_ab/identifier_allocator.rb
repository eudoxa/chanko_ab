module ChankoAb
  class IdentifierAllocator
    private attr_accessor :extractor, :digit, :radix

    def initialize(digit:, radix:, extractor:)
      self.digit = digit
      self.radix = radix
      self.extractor = extractor
    end

    def allocate(scope, cohort_size)
      return nil if cohort_size == 0

      assign_number = to_i(extract_identifier(scope))
      return nil unless assign_number
      return nil if leftover?(assign_number, cohort_size)

      return (assign_number) % cohort_size
    end

    private
    def extract_identifier(scope)
      self.extractor.call(scope)
    end

    def max_number
      radix**digit - 1
    end

    def leftover?(assign_number, cohort_size)
      leftover_border = (max_number - (max_number % cohort_size))
      assign_number >= leftover_border
    end

    def to_i(identifier)
      case identifier
      when String
        identifier.to_i(radix)
      when Integer
        integer
      else
        nil
      end
    end
  end
end
