module Bouncer

  class NoInheritanceAllowedError < StandardError; end

  class Store

    # Implement a simple Singleton pattern
    private_class_method :new
    @@listeners = []
    @@mutex = Mutex.new

    class << self

      def inherited(subclass)
        raise NoInheritanceAllowedError.new("#{self.class.to_s} is meant to be a singleton class and to not be inherited")
      end

      def register(objects, options)
        mutex.synchronize do
          objects.each { |object| @@listeners << Bouncer::Listener.new(object, options) }
        end
      end

      def unregister(objects)
        puts objects.first.inspect
        mutex.synchronize do
          objects.each { |object| listeners.delete_if { |listener| listener.object == object } }
        end
      end

      def clear
        mutex.synchronize do
          @@listeners = []
        end
      end

      def notify(scope, event, args)
        return if listeners.empty?

        listeners.select { |listener| listener.for?(scope) }.each do |listener|
          klass = listener.object
          klass.public_send(event, *args) if klass.respond_to?(event)
          listener.callback
        end
      end

      def listeners
        @@listeners
      end

      def mutex
        @@mutex
      end
    end
  end
end
