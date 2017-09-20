require 'shouter/version'
require 'shouter/hook'
require 'shouter/guard'
require 'shouter/listener'
require 'shouter/listeners/async'
require 'shouter/listeners/sync'
require 'shouter/store'
require 'shouter/builder'

module Shouter

  class ScopeMissingError < StandardError
    def initialize
      'You must supply a scope for running the events'
    end
  end

  def subscribe(*objects, **options)
    Shouter::Store.register(objects, options)
  end

  def unsubscribe(*objects)
    Shouter::Store.unregister(objects)
  end

  def publish(scope, event, *args, &block)
    Shouter::Store.notify(scope, event, args, &block)
  end

  def clear
    Shouter::Store.clear
  end
  alias_method :clear_listeners, :clear
end
