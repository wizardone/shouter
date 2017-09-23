module Shouter
  module Mixin

    def self.included(base)
      base.include InstanceMethods
    end

    module InstanceMethods

      attr_reader :object, :options, :scope

      def initialize(object, options)
        raise Shouter::ScopeMissingError unless options[:scope]

        @object = object
        @options = options
        @scope = options[:scope]
      end

      private

      def notify?(scope, event)
        return false unless notification_allowed?(event, scope)
        return false unless fire_guard!
        true
      end

      def unregister(object)
        Store.unregister(object) if single?
      end

      def notification_allowed?(event, desired_scope)
        object.respond_to?(event) && scope == desired_scope
      end

      def fire_hook!(callback)
        Shouter::Hook.(callback)
      end

      def fire_guard!
        Shouter::Guard.(options[:guard])
      end

      def single?
        options[:single] == true
      end
    end
  end
end
