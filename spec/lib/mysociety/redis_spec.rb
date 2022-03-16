# frozen_string_literal: true

require 'rails_helper'

RSpec.describe MySociety::Redis do
  around do |example|
    original_sentinels = ENV['REDIS_SENTINELS']
    ENV['REDIS_SENTINELS'] = configured_sentinels
    example.run
    ENV['REDIS_SENTINELS'] = original_sentinels
  end

  def sentinels
    described_class.options_with_namespace[:sentinels]
  end

  context 'with sentinels configured with IPv4 address without ports' do
    let(:configured_sentinels) { '0.0.0.0,0.0.0.1' }

    it 'uses default port' do
      expect(sentinels).to include(
        { host: '0.0.0.0', port: 26_379 },
        { host: '0.0.0.1', port: 26_379 }
      )
    end
  end

  context 'with sentinels configured with IPv4 address with ports' do
    let(:configured_sentinels) { '0.0.0.0:123,0.0.0.1:456' }

    it 'uses custom port' do
      expect(sentinels).to include(
        { host: '0.0.0.0', port: 123 },
        { host: '0.0.0.1', port: 456 }
      )
    end
  end

  context 'with sentinels configured with IPv6 address without ports' do
    let(:configured_sentinels) { '[::1],[::2]' }

    it 'uses default port' do
      expect(sentinels).to include(
        { host: '::1', port: 26_379 },
        { host: '::2', port: 26_379 }
      )
    end
  end

  context 'with sentinels configured with IPv6 address with ports' do
    let(:configured_sentinels) { '[::1]:123,[::2]:456' }

    it 'uses custom port' do
      expect(sentinels).to include(
        { host: '::1', port: 123 },
        { host: '::2', port: 456 }
      )
    end
  end
end
