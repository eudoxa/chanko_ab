module ChankoAb
  class SplitTest
    def initialize(unit)
      @unit = unit
      @patterns = []
      @log_templates = {}

      initialize_shared_methods
    end

    def process(caller_scope, request, identifier, &block)
      process = logic_klass.new(self, caller_scope, request, identifier, @using_index)

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

    def logic(logic)
      @logic = logic
    end

    def logic_klass
      @logic || ChankoAb.default_logic || ChankoAb::Logic::NumberIdentifier
    end

    def add(name, attributes)
      @patterns << [name, attributes]
    end

    def reset_patterns
      @patterns = []
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
end
