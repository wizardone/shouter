module Bouncer
  class Store

    # Implement a simple Singleton pattern
    private_class_method :new
    @@objects = []

    class << self

      def register(object)
        @@objects << object
      end

      def objects
        @@objects
      end
    end
  end
end
