module Shouter
  class Guard

    class << self
      def call(listener)
        listener.guard.call
      end
    end
  end
end
