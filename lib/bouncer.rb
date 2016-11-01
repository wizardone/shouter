require 'bouncer/version'
require 'bouncer/store'

module Bouncer
  class << self
    def subscribe(object, *args, &block)
      Bouncer::Store.register(object)
    end

    def publish(*args, &block)

    end

    def on(event, &block)

    end
  end
end
