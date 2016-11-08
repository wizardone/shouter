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

      def clear
        @@listeners = []
      end

      def notify(event, args)
        # Use some scope
        return if listeners.empty?

        listeners.each do |listener|
          listener.object.public_send(event, *args) if listener.for?(event)
        end
      end

      def listeners
        @@listeners
      end
    end
  end
end
