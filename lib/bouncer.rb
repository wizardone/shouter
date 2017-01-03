require 'bouncer/version'
require 'bouncer/listener'
require 'bouncer/store'

module Bouncer
  def subscribe(*objects, **options)
    Bouncer::Store.register(objects, options)
  end

  def unsubscribe(*objects)
    Bouncer::Store.unregister(objects)
  end

  def publish(scope, event, *args, &block)
    Bouncer::Store.notify(scope, event, args, &block)
  end

  def clear
    Bouncer::Store.clear
  end
  alias_method :clear_listeners, :clear
end
