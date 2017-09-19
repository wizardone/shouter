module Shouter

  class ScopeMissingError < StandardError
    def initialize
      'You must supply a scope for running the events'
    end
  end

  class Listener
    attr_reader :object, :options, :scope

    def initialize(object, options)
      raise Shouter::ScopeMissingError unless options[:scope]

      @object = object
      @options = options
      @scope = options[:scope]
    end

    def notify(scope, event, args, &block)
      return unless notification_allowed?(event, scope)

      if fire_guard!
        object.public_send(event, *args)
        fire_hook!(callback || block)

        Store.unregister(object) if single?
      end
    end

    private

    def notification_allowed?(event, desired_scope)
      object.respond_to?(event) && scope == desired_scope
    end

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
      options[:guard]
    end
  end
end
