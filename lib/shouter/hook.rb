module Shouter
  class Hook

    class << self
      def call(callback)
        # TODO: remove redundant ifs
        callback.call if callback.is_a?(Proc)
      end
    end
  end
end
