require 'spec_helper'

RSpec.describe Shouter::Builder do

  let(:object) { Class.new }
  let(:sync_options) { { scope: 'sync' } }
  let(:async_options) { { scope: 'async', async: true } }

  describe '.register' do
    it 'registers a new synchronous listener' do
      expect(Shouter::Listeners::Sync).to receive(:new).with(object, sync_options)

      described_class.register(object, sync_options)
    end

    it 'registers a new asynchronous listener' do
      expect(Shouter::Listeners::Async).to receive(:new).with(object, async_options)

      described_class.register(object, async_options)
    end
  end
end
