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
    invoke(:chanko_ab_experiment, name)
  end

  def request
    {}
  end
end

module ChankoAbExperiment
  include Chanko::Unit
  include ChankoAb
  module Logger; end

  active_if { true }

  split_test.log_template(name: 'my_log', template: 'my_log.[name]')
  split_test.define(:name, scope: ChankoAdoptedClass) do |cohort|
    cohort.name
  end

  split_test.define(:log, scope: ChankoAdoptedClass) do |cohort|
    cohort.log('my_log')
  end
end

ChankoAb.env = :test

RSpec.configure do |config|
  config.after do
    ChankoAb::Test.reset!
    ChankoAb.reset_identifier
    ChankoAbExperiment.split_test.reset_cohorts
    ChankoAbExperiment.split_test.reset_identifier
  end
end
