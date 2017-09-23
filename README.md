# Shouter
[![Build Status](https://travis-ci.org/wizardone/shouter.svg?branch=master)](https://travis-ci.org/wizardone/shouter)
[![codecov](https://codecov.io/gh/wizardone/shouter/branch/master/graph/badge.svg)](https://codecov.io/gh/wizardone/shouter)

`Shouter` is a very simple and lightweight publish/subscription DSL for
Ruby applications.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'shouter'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install shouter

## Usage
```ruby
class A
  extend Shouter
  subscribe(Listener.new, for: :my_scope)
end

class Listener
  def on_change
    "I`m changed"
  end
end

A.publish(:my_scope, :on_change)
=> "I`m changed"
```
Since version `0.1.3` if you want asyncronous execution, using separate threads you can supply
the `async` option. By default it is set to `false`
```ruby
class A
  extend Shouter
  subscribe(Listener.new, for: :my_async_scope, async: true)
end
```
Now whenever you `publish` and event it will be run in a separate
thread. If a thread for the execution is already present another one
will not be created. If you have supplied a callback option it will be
executed in the thread of execution of the listener.

You can subscribe multiple objects:
```ruby
class A
  extend Shouter
  subscribe(Listener.new, Listener1.new, Listener2.new, for: :my_scope)
end
```

You can subscribe an object for single execution, after that the object
will be removed from the listener store
```ruby
class A
  extend Shouter
  subscribe(Listener.new, for: :my_scope, single: true)
end

A.publish(:my_scope, :on_change)
=> "I`m changed"

A.publish(:my_scope, :on_change)
=> nil
```
All the arguments are passed to the method as well:
```ruby
A.publish(:my_scope, :on_change_with_arguments, 'argument_1', 'argument_2')
```

You can also pass a block to the publish method, which will serve as a
successful callback, meaning it will only get executed after the event
has been triggered
```ruby
A.publish(:my_scope, :on_change) do
  puts "I am callback"
end
```

To unsubscribe single or multiple objects you can call the `unsubscribe` method
```ruby
A.unsubscribe(Listener1, Listener2)
```

Since version `1.0.1`:

Alternatively you can pass the callback option when subscribing.
It accepts a callable object:
```ruby
subscribe(Listener.new, for: :my_scope, callback: ->() { perform_async })
```

You can now add a `guard` clause which will stop the execution of events
unless it returns `true`. Guard clauses accept callable objects
```ruby
subscribe(Listener.new, for: :my_scope, guard: Proc.new { some_listener.respond_to?(:my_method) })
```


The `clear` method removes all listeners from the store.

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/wizardone/shouter. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

