require 'spec_helper'

describe Bouncer do
  subject { Class.new }
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

        expect(Bouncer::Store).to receive(:register).with(object)

        Bouncer.subscribe(object)
      end
    end
  end

  context 'Bouncer::Store' do
    subject { Bouncer::Store }

    it 'is a singleton class' do
      expect { subject.new }.to raise_error NoMethodError
    end

    it 'registers an object in the store' do

    end

    it 'returns the current store objects' do
      object = Object.new
      subject.register(object)

      expect(subject.objects).to eq([object])
    end
  end
end
