module Bouncer
  class Listener
    attr_reader :object, :options

    def initialize(object, options)
      @object = object
      @options = options
    end

    def for?(scope)
      options[:scope] == scope
    end
  end
end
