module ChankoAb
  module Test
    def self.overwritten_names
      @overwritten_names ||= {}
      @overwritten_names
    end

    def self.overwritten_name(klass)
      self.overwritten_names[klass]
    end

    def self.overwrite(klass, name)
      self.overwritten_names[klass] = name
    end

    def self.overwritten?(klass)
      !!self.overwritten_names[klass]
    end

    def self.reset!
      @overwritten_names = {}
    end
  end
end
