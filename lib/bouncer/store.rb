require 'byebug'
module Bouncer
  class Store

    # Implement a simple Singleton pattern
    private_class_method :new
    @@listeners = []

    class << self

      def register(object, options)
        @@listeners << Bouncer::Listener.new(object, options)
      end

      def unregister(object)
        listeners.delete_if { |listener| listener.object == object }
      end

      def clear
        @@listeners = []
      end

      def notify(scope, event, args)
        return if listeners.empty?

        listeners.select { |listener| listener.for?(scope) }.each do |listener|
          klass = listener.object
          klass.public_send(event, *args) if klass.respond_to?(event)
        end
      end

      def listeners
        @@listeners
      end
    end
  end
end
