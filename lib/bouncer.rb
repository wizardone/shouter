require 'bouncer/version'
require 'bouncer/listener'
require 'bouncer/store'
require 'byebug'

module Bouncer
  def subscribe(object, **options)
    Bouncer::Store.register(object, options)
  end

  def unsubscribe(object)
    Bouncer::Store.unregister(object)
  end

  def publish(scope, event, *args)
    Bouncer::Store.notify(scope, event, args)
  end
end
