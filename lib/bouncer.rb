require 'bouncer/version'
require 'bouncer/listener'
require 'bouncer/store'
require 'byebug'

module Bouncer
  def subscribe(object, **options)
    Bouncer::Store.register(object, options)
  end

  def publish(event, *args)
    Bouncer::Store.notify(event, args)
  end
end
