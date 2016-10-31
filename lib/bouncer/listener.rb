module Bouncer
  class Listener
    attr_reader :objects
    def initialize(*objects)
      @objects = objects
    end
  end
end
