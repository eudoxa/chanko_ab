module ChankoAb
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
end
