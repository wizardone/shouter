module Shouter
  class Hook

    class << self
      def call(listener, callback)
        callback.call if callback.is_a?(Proc)
        Store.unregister(listener.object) if listener.single?
      end
    end
  end
end
