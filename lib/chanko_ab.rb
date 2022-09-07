require "chanko_ab/version"
require "chanko_ab/test"
require "chanko_ab/split_test"
require "chanko_ab/logic/base"
require "chanko_ab/logic/number_identifier"
require "chanko_ab/logic/hex_identifier"

module ChankoAb
  module ClassMethods
    def split_test
      @split_test ||= SplitTest.new(self)
    end
  end

  def self.included(klass)
    klass.extend(ClassMethods)
  end

  def self.set_logging(&block)
    @logging_proc = block
  end

  def self.set_identifier(&block)
    @identifier_proc = block
  end

  def self.identifier_proc
    @identifier_proc
  end

  def self.default_logic
    @default_logic
  end

  def self.set_default_logic(logic)
    @default_logic = logic
  end

  def self.log(caller_scope, name, options)
    raise 'Should implement logging proc via ChankoAb.set_logging {}' unless @logging_proc
    caller_scope.instance_exec(name, options, &@logging_proc)
  end
end
