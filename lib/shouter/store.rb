module Shouter

  NoInheritanceAllowedError = Class.new(StandardError)

  class Store

    # Implement a simple Singleton pattern
    private_class_method :new

    @@listeners = []
    @@mutex = Mutex.new

    class << self

      def inherited(subclass)
        raise NoInheritanceAllowedError.new("#{self.class.to_s} is meant to be a singleton class and not to be inherited")
      end

      def register(objects, options)
        mutex.synchronize do
          objects.each do |object|
            subscribed_objects = @@listeners.map(&:object)
            @@listeners << Shouter::Listener.new(object, options) unless subscribed_objects.include?(object)
          end
        end
      end

      def unregister(objects)
        mutex.synchronize do
          [*objects].each { |object| listeners.delete_if { |listener| listener.object == object } }
        end
      end

      def clear
        mutex.synchronize do
          @@listeners = []
        end
      end

      def notify(scope, event, args, &block)
        return if listeners.empty?

        listeners.each { |listener| listener.notify(scope, event, args, &block) }
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
