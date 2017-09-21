module Shouter
  module Listeners
    class Async

      include Shouter::Mixin

      attr_reader :object, :options, :scope, :thread_exists

      def notify(scope, event, args, &block)
        return unless notification_allowed?(event, scope)
        return unless fire_guard!
        return if thread_exists?

        create_thread

        Thread.new do
          object.public_send(event, *args)
          fire_hook!(callback || block)
        end
        Store.unregister(object) if single?
      end

      private

      # If a thread is already spawned for this listener
      # do not create another one
      def thread_exists?
        thread_exists
      end

      def create_thread
        @thread_exists = true
      end
    end
  end
end
