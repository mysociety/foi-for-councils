# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Foi::ContactsController, type: :controller do
  describe 'GET #show' do
    it 'returns http success' do
      get :show, params: { request_id: '1' }
      expect(response).to have_http_status(200)
    end
  end

  describe 'PUT #update' do
    it 'returns http success' do
      put :update, params: { request_id: '1' }
      expect(response).to have_http_status(204)
    end
  end
end
