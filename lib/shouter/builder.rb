module Shouter
  class Builder
    class << self
      def register(object, options)
        if options[:async]
          Shouter::Listeners::Async.new(object, options)
        else
          Shouter::Listeners::Sync.new(object, options)
        end
        #Shouter::Listener.new(object, options)
      end
    end
  end
end
