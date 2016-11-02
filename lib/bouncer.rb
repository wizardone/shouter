require 'bouncer/version'
require 'bouncer/listener'
require 'bouncer/store'
require 'byebug'
module Bouncer
  def subscribe(object, opts = {})
    Bouncer::Store.register(object, opts)
  end

  def publish(*args, &block)

  end

  def on(event)
    Bouncer::Store.notify(event)
  end
end
