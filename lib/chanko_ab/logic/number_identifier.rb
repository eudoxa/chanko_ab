require "chanko_ab/version"

module ChankoAb
  module Logic
    class NumberIdentifier < Base
      def just_pattern_sizes
        [1, 2, 5, 10]
      end

      def assigned_number
        @identifier.slice(-(@using_index + 1)).to_i
      end
    end
  end
end
