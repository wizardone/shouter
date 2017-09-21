require 'spec_helper'

RSpec.describe Shouter::Listeners::Async do

  let(:object) do
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

  describe '#initialize' do
    it 'initializes the listener class' do
      listener = described_class.new(Class.new, scope: :main)

      expect(listener.object).to be_a(Class)
      expect(listener.options).to be_a(Hash)
    end

    it 'raises an error if no event scope is provided' do
      expect {
        described_class.new(Class.new, {})
      }.to raise_error(Shouter::ScopeMissingError)
    end
  end

  describe '#notify' do

    let(:callback) { ->() { puts 'Some callback' } }
    let(:listener) { described_class.new(object, scope: :main) }
    let(:guard_listener) do
      described_class.new(object, scope: :main, guard: -> { false })
    end
    let(:callback_listener) do
      described_class.new(object, scope: :main, callback: callback)
    end

    it 'sends the event to the object' do
      expect(object).to receive(:on_change)

      listener.notify(:main, :on_change, [])
      sleep 0.1
    end

    it 'does not send the event because of wrong scope' do
      expect(object).to_not receive(:on_change)

      listener.notify(:dummy, :on_change, [])
    end

    it 'does not send the event because of guard clause' do
      expect(Shouter::Guard).to receive(:call) { false }
      expect(object).to_not receive(:on_change)

      guard_listener.notify(:main, :on_change, [])
    end

    it 'executes the provided callback' do
      expect(Shouter::Hook).to receive(:call).with(callback)

      callback_listener.notify(:main, :on_change, [])
      sleep 0.1
    end
  end

  context 'scope execution' do

    let(:listener_object) { described_class.new(object, scope: :test) }

    it 'executes the listener if the proper scope is present' do
      expect(object).to receive(:on_change)

      listener_object.notify(:test, :on_change, [])
      sleep 0.1
    end

    it 'does not execute the listener if the scope is wrong' do
      expect(object).to_not receive(:on_change)

      listener_object.notify(:bollocks, :on_change, [])
    end
  end
end

