# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'assets', type: :request do
  it 'precompiles every asset that a page links to' do
    get '/foi/request/new'

    urls = response.body.scan(%r{"/assets/([^"]+)"}).flatten
    logical_paths = urls.map do |url|
      url.sub(/-\h{64}(?=\.)/, '').sub('.debug', '')
    end

    expect(logical_paths).to include('hackney-template.css', 'application.js')
    expect(Rails.application.precompiled_assets).to include(*logical_paths)
  end
end
