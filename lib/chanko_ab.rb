require "chanko_ab/version"

module ChankoAb
  def self.set_logging(&block)
    @logging_proc = block
  end

  def self.set_identifier(&block)
    @identifier_proc = block
  end

  def self.identifier_proc
    @identifier_proc
  end

  def self.log(caller_scope, name, options)
    raise NotImplementedError unless @logging_proc
    caller_scope.instance_exec(name, options, &@logging_proc)
  end

  module Process
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

      def should_run_default?
        raise NotImplementedError
      end
      private :should_run_default?

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
          return nil unless index
          return patterns[index]
        end
      end

      def patterns
        @split_test.patterns
      end
      private :patterns

      def decide_pattern_index
        #e.g
        raise NotImplementedError
      end
      private :decide_pattern_index
    end

    class NumberIdentifier < Base
      JUST_PATTERN_SIZES = [1, 2, 5, 10]
      def should_run_default?
        return true if !item
        @identifier.blank?
      end

      def sample_padding(size)
        return 0 if size == 0
        raise 'too large size' if size >= 10
        JUST_PATTERN_SIZES.each do |n|
          padding = n - size;
          return padding if padding >= 0
        end
      end

      def ab_index(identifier, size, using_index)
        unless Rails.env.production?
          raise "argument should be a divisor of 10 but #{size}" if !JUST_PATTERN_SIZES.member?(size)
          raise "identifier is blank" if identifier.blank?
          raise "using_index error" if identifier.size <= (using_index + 1)
        end
        using_number = identifier.slice(-(using_index + 1)).to_i
        using_number % size
      end

      def decide_pattern_index
        filled_patterns = patterns + ([nil] * sample_padding(patterns.size))
        ab_index(@identifier, filled_patterns.size, @using_index)
      end
    end
  end

  class SplitTest
    def initialize(unit)
      @unit = unit
      @patterns = []
      @log_templates = {}

      initialize_shared_methods
    end

    def process(caller_scope, request, identifier, &block)
      process = ChankoAb::Process::NumberIdentifier.new(self, caller_scope, request, identifier, @using_index)

      processes.push(process)
      begin
        block.call(process)
      ensure
        processes.pop
      end
    end

    def unit
      @unit
    end

    def add(name, attributes)
      @patterns << [name, attributes]
    end

    def log_template(name, template)
      @log_templates[name] = template
    end

    def patterns
      @patterns
    end

    def fetch_template(name)
      @log_templates[name]
    end

    def processes
      @processes ||= []
    end

    def using_index(index)
      @using_index = index
    end

    def use_user_via(&user_proc)
      @user_proc = user_proc
    end

    def user_ab?
      !!@user_proc
    end

    def define(key, options = {}, &block)
      __split_test__ = self
      unit.class_eval do
        scope(options[:scope] || :view) do
          function(key) do
            __split_test__.process(self, request, identifier) do |process|
              next run_default if process.should_run_default?
              self.instance_eval(&block)
            end
          end
        end
      end
    end

    def initialize_shared_methods
      __split_test__ = self
      @unit.class_eval do
        shared(:unit_name) do
          @units.last.name
        end

        shared(:ab) do
          __split_test__.processes.last
        end

        shared(:identifier) do
          self.instance_eval(&ChankoAb.identifier_proc)
        end
      end
    end
    private :initialize_shared_methods
  end

  module Test
    def self.overwritten_name(klass)
      @overwritten_names[klass]
    end

    def self.overwrite(klass, name)
      @overwritten_names ||= {}
      @overwritten_names[klass] = name
    end

    def self.overwritten?(klass)
      !!@overwritten_names[klass]
    end

    def self.reset!
      @overwritten_names = {}
    end
  end

  module ClassMethods
    def split_test
      @split_test ||= SplitTest.new(self)
    end
  end

  def self.included(klass)
    klass.extend(ClassMethods)
  end
end
