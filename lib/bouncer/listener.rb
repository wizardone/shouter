module Bouncer
  class Listener
    attr_reader :object, :options

    def initialize(object, options)
      @object = object
      @options = options
    end

    def for?(event)
      options[:scope] == event
    end
  end
end
