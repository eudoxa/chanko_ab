module ChankoAb
  module Logic
    class Base
      def initialize(split_test, caller_scope, request, identifier, using_index)
        @split_test = split_test
        @caller_scope = caller_scope
        @request = request
        @identifier = identifier
        @using_index = using_index || 0
        @data = {}
      end

      def data(name, &block)
        @data[name] ||= block.call
      end

      def just_pattern_sizes
        raise NotImplementedError
      end

      def validate!
        unless Rails.env.production?
          raise "Argument should be a divisor of #{just_patterns_size.max}, but #{split_size} is given." if !just_patterns_size.member?(split_size)
          raise "Identifier is blank" if @identifier.blank?
          raise "Identifier is too short" if @identifier.size < (@using_index + 1)
          raise 'Too large pattern size' if patterns.size >= just_pattern_sizes.max
        end
      end

      def ab_index
        assigned_number % split_size
      end

      def should_run_default?
        return true if !item
        @identifier.blank?
      end

      def pattern_by_overwritten
        overwritten_name = ChankoAb::Test.overwritten_name(@split_test.unit)
        pattern = patterns.detect { |pt| pt[0] == overwritten_name }
        pattern || raise("ChankoAb: specified no defined name '#{overwritten_name}'")
      end
      private :pattern_by_overwritten

      def name
        item[0]
      end

      def fetch(key)
        item[1][key]
      end

      def log_key(template_name)
        template = @split_test.fetch_template(template_name)
        template.gsub('[name]', name)
      end

      def log(template_name)
        ChankoAb.log(@caller_scope, log_key(template_name), request: @request, identifier: @identifier)
      end

      def item
        if Rails.env.test? && ChankoAb::Test.overwritten?(@split_test.unit)
          return pattern_by_overwritten
        else
          index = decide_pattern_index
          return nil if index > patterns.size
          return patterns[index]
        end
      end

      def patterns
        @split_test.patterns
      end
      private :patterns

      def decide_pattern_index
        return 0 if patterns.size == 0
        ab_index
      end
      private :decide_pattern_index

      def split_size
        just_pattern_sizes.select { |_size| _size >= patterns.size }.min
      end
      private :split_size

      def assigned_number
        raise NotImplementedNumber
      end
      private :assigned_number
    end
  end
end
