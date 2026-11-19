# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'session cookie', type: :request do
  let(:sha1_key_generator) do
    ActiveSupport::CachingKeyGenerator.new(
      ActiveSupport::KeyGenerator.new(
        Rails.application.secret_key_base,
        iterations: 1000, hash_digest_class: OpenSSL::Digest::SHA1
      )
    )
  end

  it 'reads a session written before the Rails 6.0 defaults' do
    allow(Rails.application).to receive(:env_config).and_wrap_original do |m|
      m.call.merge('action_dispatch.key_generator' => sha1_key_generator,
                   'action_dispatch.use_cookies_with_metadata' => false)
    end
    post '/foi/request', params: { foi_request: { body: 'Housing budget' } }

    allow(Rails.application).to receive(:env_config).and_call_original
    get '/foi/request/edit'
    expect(response.body).to include('Housing budget')
  end
end
