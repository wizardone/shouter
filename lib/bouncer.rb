require 'bouncer/version'
require 'bouncer/listener'
require 'bouncer/store'
require 'byebug'

module Bouncer
  def subscribe(object, opts = {})
    Bouncer::Store.register(object, opts)
  end

  def publish(event, *args)
    Bouncer::Store.notify(event, args)
  end
end
