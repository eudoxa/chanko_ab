require "chanko_ab/version"
require "chanko_ab/test"
require "chanko_ab/cohort"
require "chanko_ab/split_test"
require "chanko_ab/identifier_allocator"

module ChankoAb
  def self.env=(env)
    @env = env
  end

  def self.env
    @env
  end

  module ClassMethods
    def split_test
      @split_test ||= SplitTest.new(self)
    end
  end

  def self.included(klass)
    klass.extend(ClassMethods)
  end

  def self.logging(&block)
    @logging_proc = block
  end

  def self.identifier(digit: 1, radix: 10, extractor:)
    @default_identifier_allocator = IdentifierAllocator.new(digit: digit, radix: radix, extractor: extractor)
  end

  def self.default_identifier_allocator
    @default_identifier_allocator
  end

  def self.reset_identifier
    @default_identifier_allocator = nil
  end

  def self.log(name, attributes)
    raise 'Should implement logging proc via ChankoAb.set_logging {}' unless @logging_proc
    @logging_proc.call(name, attributes)
  end
end
