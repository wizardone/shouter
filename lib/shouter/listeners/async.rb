module Shouter
  module Listeners
    class Async

      include Shouter::Mixin

      attr_reader :thread_exists

      def notify!(scope, event, args, &block)
        return unless notify?(scope, event)
        return if thread_exists?

        create_thread
        Thread.new do
          object.public_send(event, *args)
          fire_hook!(options[:callback] || block)
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
