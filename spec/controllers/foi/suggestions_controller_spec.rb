# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Foi::SuggestionsController, type: :controller do
  describe 'GET #index' do
    it 'returns http success' do
      get :index, params: { request_id: '1' }
      expect(response).to have_http_status(200)
    end
  end
end
