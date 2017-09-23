module Shouter
  class Builder
    class << self
      def register(object, options)
        if options[:async]
          _klass = Shouter::Listeners::Async
        else
          _klass = Shouter::Listeners::Sync
        end
        _klass.new(object, options)
      end
    end
  end
end
