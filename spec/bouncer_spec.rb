require 'spec_helper'

describe Bouncer do
  subject do
    Class.new do
      extend Bouncer
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
    end.new
  end

  before { Bouncer::Store.clear }

  it 'has a version number' do
    expect(Bouncer::VERSION).not_to be nil
  end

  it 'does something useful' do
    expect(subject).to be_a(Class)
  end

  context 'main interface' do
    describe '.subscribe' do
      it 'sends the object to the store' do
        object = Object.new
        options = { scope: 'scope' }

        expect(Bouncer::Store).to receive(:register).with([object], options)

        subject.subscribe(object, options)
      end

      it 'sends the options to the listener' do
        object = Object.new
        options = { scope: 'updates' }

        subject.subscribe(object, options)

        expect(Bouncer::Store.listeners).not_to be_empty
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
        expect(Bouncer::Store).to receive(:unregister).with([object])

        subject.unsubscribe(object)
      end

      it 'unsubscribes an object from the store' do
        expect(Bouncer::Store.listeners.first.object).to eq(object)

        subject.unsubscribe(object)

        expect(Bouncer::Store.listeners).to be_empty
      end

      it 'unsubscribes multiple objects from the store' do
        subject.subscribe(object_1, scope: 'scope')
        subject.subscribe(object_2, scope: 'scope')

        subject.unsubscribe(object_1, object_2)

        expect(Bouncer::Store.listeners.first.object).to eq(object)
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
    end

    describe '.clear' do
      it 'clears all listeners' do
        subject.subscribe(listener, scope: :main)
        subject.subscribe(listener, scope: :main)

        subject.clear_listeners

        expect(Bouncer::Store.listeners).to eq([])
      end
    end
  end

  context 'Bouncer::Store' do
    subject { Bouncer::Store }

    it 'is a singleton class' do
      expect { subject.new }.to raise_error NoMethodError
    end

    it 'does not allow inheritence' do
      expect {
        Class.new(subject) do; end
      }.to raise_error(Bouncer::NoInheritenceAllowedError)
    end

    it 'returns the current store objects' do
      object = Object.new
      options = { scope: 'scope', default: true }

      subject.register([object], options)

      expect(subject.listeners).not_to be_empty
      expect(subject.listeners.size).to eq 1
      expect(subject.listeners.first).to be_a(Bouncer::Listener)
    end
  end

  context 'Bouncer::Listener' do
    describe '#initialize' do
      it 'initializes the listener class' do
        listener = Bouncer::Listener.new(Class.new, scope: :main)

        expect(listener.object).to be_a(Class)
        expect(listener.options).to be_a(Hash)
      end

      it 'raises an error if no event scope is provided' do
        expect {
          Bouncer::Listener.new(Class.new, {})
        }.to raise_error(Bouncer::ScopeMissingError)
      end
    end

    describe '#callback' do
      let(:listener) { Bouncer::Listener.new(Class.new, scope: 'test', single: true) }

      it 'performs a callback action on the listener' do
        expect(Bouncer::Store).to receive(:unregister).with(listener.object).once

        listener.callback
      end
    end

    describe '#for?' do
      let(:listener) { Bouncer::Listener.new(Class.new, scope: :test) }

      it 'returns true - the listener is for the scope' do
        expect(listener.for?(:test)).to be_truthy
      end

      it 'returns false - the listener is not for the scope' do
        expect(listener.for?(:other_test)).to be_falsey
      end
    end

    describe '#single?' do
      let(:listener) { Bouncer::Listener.new(Class.new, scope: 'test', single: true) }

      it 'returns true - the listener is for the scope' do
        expect(listener.single?).to be_truthy
      end
    end
  end
end
