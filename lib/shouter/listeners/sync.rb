require 'byebug'
module Shouter
  module Listeners
    class Sync

      include Shouter::Mixin

      def notify!(scope, event, args, &block)
        return unless notify?(scope, event)

        object.public_send(event, *args)
        fire_hook!(options[:callback] || block)

        Store.unregister(object) if single?
      end
    end
  end
end
