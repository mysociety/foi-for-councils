# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Foi::SuggestionsController, type: :controller do
  let(:foi_request) { build_stubbed(:foi_request) }

  before do
    allow(FoiRequest).to receive(:find).with('1').and_return(foi_request)
  end

  describe 'GET #index' do
    it 'returns http success' do
      get :index, params: { request_id: '1' }
      expect(response).to have_http_status(200)
    end
  end
end
