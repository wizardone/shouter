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

    def for?(scope)
      options[:scope] == scope
    end

    def single?
      options[:single] == true
    end

    def if
      options[:if]
    end
  end
end
