require 'byebug'
module Shouter
  module Listeners
    class Sync

      include Shouter::Mixin

      attr_reader :object, :options, :scope

      def notify(scope, event, args, &block)
        return unless notification_allowed?(event, scope)
        return unless fire_guard!

        object.public_send(event, *args)
        fire_hook!(callback || block)

        Store.unregister(object) if single?
      end
    end
  end
end
