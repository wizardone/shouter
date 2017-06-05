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

    def notify(event, args, block)
      return unless object.respond_to?(event)

      fire_guard!
      object.public_send(event, args)
      fire_hook!(block)
    end

    def fire_hook!(callback)
      Shouter::Hook.(callback)
    end

    def fire_guard!
      Shouter::Guard.(guard)
    end

    def for?(scope)
      options[:scope] == scope
    end

    def single?
      options[:single] == true
    end

    private

    def guard
      options[:guard] || -> {}
    end
  end
end
