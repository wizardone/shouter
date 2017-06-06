module Shouter
  class Guard

    class << self
      def call(guard)
        return true unless guard
        guard.call
      end
    end
  end
end
