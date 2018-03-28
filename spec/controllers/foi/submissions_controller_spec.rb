# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Foi::SubmissionsController, type: :controller do
  describe 'PUT #update' do
    it 'returns http success' do
      put :update, params: { request_id: '1' }
      expect(response).to have_http_status(204)
    end
  end

  describe 'GET #show' do
    it 'returns http success' do
      get :show, params: { request_id: '1' }
      expect(response).to have_http_status(200)
    end
  end
end
