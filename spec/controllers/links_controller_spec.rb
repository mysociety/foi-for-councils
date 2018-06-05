# frozen_string_literal: true

require 'rails_helper'

RSpec.describe LinksController, type: :controller do
  describe 'GET #show' do
    subject { get :show, params: { id: '1' } }

    let(:suggestion) { build_stubbed(:foi_suggestion) }

    before do
      allow(FoiSuggestion).to receive(:find).with('1').and_return(suggestion)
      allow(suggestion).to receive(:clicked!)
      allow(suggestion).to receive(:url).and_return('http://example.com')
    end

    it 'call clicked! on suggestion' do
      expect(suggestion).to receive(:clicked!)
      subject
    end

    it 'redirects suggestion URL' do
      is_expected.to redirect_to('http://example.com')
    end
  end
end
