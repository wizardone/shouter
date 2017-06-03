module Shouter

  class ScopeMissingError < StandardError
    def initialize
      'You must supply a scope for running the events'
    end
  end

  class Listener
    attr_reader :object, :options

    def initialize(object, options)
      raise Shouter::ScopeMissingError unless options[:scope]

      @object = object
      @options = options
    end

    def fire_hook!(callback)
      Shouter::Hook.(self, callback)
    end

    def fire_guard!
      Shouter::Guard.(self)
    end

    def for?(scope)
      options[:scope] == scope
    end

    def single?
      options[:single] == true
    end

    def guard
      options[:guard]
    end
  end
end
