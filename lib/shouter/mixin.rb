module Shouter
  module Mixin

    def self.included(base)
      base.include InstanceMethods
    end

    module InstanceMethods

      def initialize(object, options)
        raise Shouter::ScopeMissingError unless options[:scope]

        @object = object
        @options = options
        @scope = options[:scope]
      end

      def notify(scope, event, args, &block)
        return unless notification_allowed?(event, scope)
        return unless fire_guard!
      end

      private

      def notification_allowed?(event, desired_scope)
        object.respond_to?(event) && scope == desired_scope
      end

      def fire_hook!(callback)
        Shouter::Hook.(callback)
      end

      def fire_guard!
        Shouter::Guard.(guard)
      end

      def callback
        options[:callback]
      end

      def single?
        options[:single] == true
      end

      def guard
        options[:guard]
      end
    end
  end
end
