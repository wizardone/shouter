require 'spec_helper'

describe Bouncer do
  subject do
    Class.new do
      extend Bouncer
    end
  end

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
        options = { scope: 'scope', default: true }

        expect(Bouncer::Store).to receive(:register).with(object, options)

        subject.subscribe(object, options)
      end
    end

    describe '.on' do
      pending
    end
  end

  context 'Bouncer::Store' do
    subject { Bouncer::Store }
    before { Bouncer::Store.clear }

    it 'is a singleton class' do
      expect { subject.new }.to raise_error NoMethodError
    end

    it 'returns the current store objects' do
      object = Object.new
      options = { scope: 'scope', default: true }

      subject.register(object, options)

      expect(subject.listeners).not_to be_empty
      expect(subject.listeners.size).to eq 1
      expect(subject.listeners.first).to be_a(Bouncer::Listener)
    end
  end

  context 'Bouncer::Listener' do
    describe '#initialize' do
      it 'initializes the listener class' do
        listener = Bouncer::Listener.new(Class.new, {})

        expect(listener.object).to be_a(Class)
        expect(listener.options).to be_a(Hash)
      end
    end
  end
end
