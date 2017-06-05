require 'byebug'
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

    def notify(event, args, &block)
      return unless object.respond_to?(event)

      fire_guard!
      object.public_send(event, *args)
      fire_hook!(block || callback)

      Store.unregister(object) if single?
    end

    def for?(scope)
      options[:scope] == scope
    end

    private

    def fire_hook!(callback)
      Shouter::Hook.(callback)
    end

    def fire_guard!
      Shouter::Guard.(guard)
    end

    def callback
      options[:callback]
    end

    def single?
      options[:single] == true
    end

    def guard
      options[:guard] || -> {}
    end
  end
end
