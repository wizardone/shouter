module Shouter
  class Guard

    class << self
      def call(guard)
        guard.call
      end
    end
  end
end
