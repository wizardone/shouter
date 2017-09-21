require 'spec_helper'

describe Shouter do
  subject do
    Class.new do
      extend Shouter
    end
  end

  let(:listener) do
    Class.new do
      def on_change
        'on_change'
      end

      def on_change_with_args(arg1, arg2)
        "with args #{arg1} #{arg2}"
      end

      def callback
        'I am callback'
      end
    end.new
  end

  before { Shouter::Store.clear }

  it 'has a version number' do
    expect(Shouter::VERSION).not_to be nil
  end

  it 'does something useful' do
    expect(subject).to be_a(Class)
  end

  context 'main interface' do
    describe '.subscribe' do

      let(:object) { Object.new }

      it 'sends the object to the store' do
        options = { scope: 'scope' }

        expect(Shouter::Store).to receive(:register).with([object], options)

        subject.subscribe(object, options)
      end

      it 'sends the options to the listener' do
        options = { scope: 'updates' }

        subject.subscribe(object, options)

        expect(Shouter::Store.listeners).not_to be_empty
      end

      it 'does not subscribe the same object twice' do
        subject.subscribe(object, object, scope: 'unique')

        expect(Shouter::Store.listeners.length).to eq(1)
      end
    end

    describe '.unsubscribe' do
      let(:object) { Object.new }
      let(:object_1) { Object.new }
      let(:object_2) { Object.new }

      before do
        subject.subscribe(object, scope: 'scope')
      end

      it 'sends the unsubscribe request to the store' do
        expect(Shouter::Store).to receive(:unregister).with([object])

        subject.unsubscribe(object)
      end

      it 'unsubscribes an object from the store' do
        expect(Shouter::Store.listeners.first.object).to eq(object)

        subject.unsubscribe(object)

        expect(Shouter::Store.listeners).to be_empty
      end

      it 'unsubscribes multiple objects from the store' do
        subject.subscribe(object_1, scope: 'scope')
        subject.subscribe(object_2, scope: 'scope')

        subject.unsubscribe(object_1, object_2)

        expect(Shouter::Store.listeners.first.object).to eq(object)
      end
    end

    describe '.publish' do
      it 'publishes an event to all listeners without arguments' do
        subject.subscribe(listener, scope: :main)

        expect(listener).to receive(:on_change)

        subject.publish(:main, :on_change)
      end

      it 'publishes an event to all listeners with arguments' do
        subject.subscribe(listener, scope: :main)

        expect(listener).to receive(:on_change_with_args).with('first', 'second')

        subject.publish(:main, :on_change_with_args, 'first', 'second')
      end

      it 'does not publish event to listeners in another scope' do
        subject.subscribe(listener, scope: :bogus)

        expect(listener).not_to receive(:on_change)

        subject.publish(:main, :on_change)
      end

      it 'removes the listener from the store if it is single' do
        subject.subscribe(listener, scope: :main, single: true)
        expect(Shouter::Store.listeners).to_not be_empty

        subject.publish(:main, :on_change)

        expect(Shouter::Store.listeners).to be_empty
      end
    end

    describe '.clear' do
      it 'clears all listeners' do
        subject.subscribe(listener, scope: :main)
        subject.subscribe(listener, scope: :main)

        subject.clear_listeners

        expect(Shouter::Store.listeners).to be_empty
      end
    end
  end

  context 'Shouter::Store' do
    subject { Shouter::Store }

    it 'is a singleton class' do
      expect { subject.new }.to raise_error NoMethodError
    end

    it 'does not allow inheritence' do
      expect {
        Class.new(subject) do; end
      }.to raise_error(Shouter::NoInheritanceAllowedError)
    end

    it 'returns the current store objects' do
      object = Object.new
      options = { scope: 'scope', default: true }

      subject.register([object], options)

      expect(subject.listeners).not_to be_empty
      expect(subject.listeners.size).to eq 1
      expect(subject.listeners.first).to be_a(Shouter::Listeners::Sync)
    end
  end

  context 'threadsafety' do
    it 'subscribes to the store via multiple threads' do
      count = 50
      [].tap do |threads|
        threads << Thread.new { count.times { subject.subscribe(Object.new, scope: 'main') } }
      end.each(&:join)

      expect(Shouter::Store.listeners.count).to eq(count)
    end
  end

  context 'guard clauses' do
    it 'allows the execution of events' do
      subject.subscribe(listener, scope: :main, guard: ->() { listener.respond_to?(:on_change) })

      expect(listener).to receive(:on_change)

      subject.publish(:main, :on_change)
    end

    it 'stops the execution of events' do
      subject.subscribe(listener, scope: :main, guard: ->() { listener.is_a?(Hash) })

      expect(listener).not_to receive(:on_change)

      subject.publish(:main, :on_change)
    end
  end

  context 'callbacks' do
    it 'invokes a callback block' do
      subject.subscribe(listener, scope: :main)

      expect(listener).to receive(:on_change).ordered
      expect(listener).to receive(:callback).ordered

      subject.publish(:main, :on_change) do
        listener.callback
      end
    end

    it 'invokes a dedicated callback' do
      callback = -> { listener.callback }
      subject.subscribe(listener, scope: :main, callback: callback)

      expect(listener).to receive(:on_change).ordered
      expect(listener).to receive(:callback).ordered

      subject.publish(:main, :on_change)
    end
  end
end
