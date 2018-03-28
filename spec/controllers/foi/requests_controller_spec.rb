# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Foi::RequestsController, type: :controller do
  describe 'GET #index' do
    it 'returns http success' do
      get :index
      expect(response).to have_http_status(200)
    end
  end

  describe 'GET #new' do
    it 'returns http success' do
      get :new
      expect(response).to have_http_status(200)
    end
  end

  describe 'POST #create' do
    it 'returns http success' do
      post :create
      expect(response).to have_http_status(204)
    end
  end

  describe 'GET #show' do
    it 'returns http success' do
      get :show, params: { id: '1' }
      expect(response).to have_http_status(200)
    end
  end

  describe 'GET #edit' do
    it 'returns http success' do
      get :edit, params: { id: '1' }
      expect(response).to have_http_status(200)
    end
  end

  describe 'PUT #update' do
    it 'returns http success' do
      put :update, params: { id: '1' }
      expect(response).to have_http_status(204)
    end
  end
end
