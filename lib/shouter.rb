require 'shouter/version'
require 'shouter/callback'
require 'shouter/listener'
require 'shouter/store'

module Shouter
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
