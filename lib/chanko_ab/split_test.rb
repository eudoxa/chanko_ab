module ChankoAb
  class SplitTest
    attr_accessor :log_templates, :unit, :cohorts
    def initialize(unit)
      self.unit = unit
      self.cohorts = []
      self.log_templates = {}
    end

    def identifier(digit: 1, radix: 10, extractor:)
      @identifier_allocator = IdentifierAllocator.new(digit: digit, radix: radix, extractor: extractor)
    end

    def identifier_allocator
      @identifier_allocator || ChankoAb.default_identifier_allocator || raise('Should set identifier')
    end

    def reset_identifier
      @identifier_allocator = nil
    end

    def log_template(name:, template:)
      self.log_templates[name] = template
    end

    def add_cohort(name:, attributes:)
      self.cohorts << Cohort.new(name, attributes, self)
    end

    def reset_cohorts
      self.cohorts = []
    end

    def define(key, options = {}, &block)
      _split = self
      self.unit.class_eval do
        scope(options[:scope] || :view) do
          function(key) do
            invoking_context = self
            next invoking_context.instance_exec(_split.overwritten_cohort, &block) if _split.overwritten?

            cohort = _split.identifier_allocator.allocate(invoking_context, _split.cohorts.size).then do |allocated_number|
              next nil unless allocated_number
              _split.cohorts[allocated_number]
            end
            next run_default unless cohort

            invoking_context.instance_exec(cohort, &block)
          end
        end
      end
    end

    def overwritten?
      (Rails.env.test? || ChankoAb.env == :test) && ChankoAb::Test.overwritten?(self.unit)
    end

    def overwritten_cohort
      overwritten_name = ChankoAb::Test.overwritten_name(self.unit)
      cohort = cohorts.detect { |c| c.name == overwritten_name }
      return cohort || raise("ChankoAb: specified no defined name '#{overwritten_name}'")
    end
  end
end
