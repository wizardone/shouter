require 'spec_helper'

describe Bouncer do
  subject { Class.new }
  it 'has a version number' do
    expect(Bouncer::VERSION).not_to be nil
  end

  it 'does something useful' do
    expect(subject).to be_a(Class)
  end
end
