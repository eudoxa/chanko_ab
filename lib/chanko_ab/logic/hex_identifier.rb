require "chanko_ab/version"

module ChankoAb
  module Logic
    class HexIdentifier < Base
      def just_pattern_sizes
        [1, 2, 4, 8, 16]
      end

      def assigned_number
        @identifier.slice(-(@using_index + 1)).to_i(16)
      end
    end
  end
end
