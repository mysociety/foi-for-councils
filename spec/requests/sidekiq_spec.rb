# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'sidekiq web', type: :request do
  describe 'GET /sidekiq' do
    it 'renders the dashboard' do
      get '/sidekiq'
      expect(response).to have_http_status(:ok)
    end
  end
end
