require 'rubygems'
require 'chanko'
require 'chanko_ab'

class Chanko::Loader
  def add_autoload_path
    # Ignored
  end
end

class ChankoAdoptedClass
  include Chanko::Invoker

  def call(name)
    invoke(:chanko_ab_test, name)
  end

  def request
    {}
  end
end

module ChankoAbTest
  include Chanko::Unit
  include ChankoAb
  module Logger; end

  active_if { true }

  split_test.log_template('my_log' ,'my_log.[name]')
  split_test.define(:name, scope: ChankoAdoptedClass) do
    ab.name
  end

  split_test.define(:log, scope: ChankoAdoptedClass) do
    ab.log('my_log')
  end
end

ChankoAb.env = :test
