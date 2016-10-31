require 'spec_helper'

describe Bouncer do
  subject { Class.new }
  it 'has a version number' do
    expect(Bouncer::VERSION).not_to be nil
  end

  it 'does something useful' do
    expect(subject).to be_a(Class)
  end

  context 'Bouncer::Store' do

    it 'is a singleton class' do
      expect { Bouncer::Store.new }.to raise_error NoMethodError
    end

    it 'registers an object in the store' do

    end

    it 'returns the current store objects' do
      object = Object.new
      Bouncer::Store.register(object)

      expect(Bouncer::Store.objects).to eq([object])
    end
  end
end
