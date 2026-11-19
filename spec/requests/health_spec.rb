# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'health namespace', type: :request do
  describe 'GET /health' do
    it 'redirects to metrics index' do
      get '/health'
      expect(response).to redirect_to('/health/metrics')
    end
  end

  describe 'GET /up' do
    it 'reports that the app booted' do
      get '/up'
      expect(response).to have_http_status(:ok)
    end
  end

  describe 'GET /health/metrics' do
    it 'renders the metrics' do
      create(:submission_with_foi_request, :unqueued)
      get '/health/metrics'
      expect(response.body).to include('app_queuable_submissions 1')
    end
  end
end
