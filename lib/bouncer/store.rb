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

      def notify(event)
        # notify all listeners
        return if listeners.empty?
        listeners.each do |listener|
          listener.public_send(event)
        end
      end

      def listeners
        @@listeners
      end
    end
  end
end
