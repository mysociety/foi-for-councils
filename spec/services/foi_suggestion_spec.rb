# frozen_string_literal: true

require 'rails_helper'

RSpec.describe FoiSuggestion, type: :service do
  describe '.from_text' do
    subject { described_class.from_text(text) }

    context 'with matching text and keywords' do
      let(:text) { 'What is the budget for housing in 2018?' }
      before { create(:curated_link, keywords: 'housing budget') }

      it 'returns the matched selections' do
        is_expected.not_to be_empty
      end
    end

    context 'with non-matching text and keywords' do
      let(:text) { 'Give me information on houses' }

      it 'returns an empty array' do
        is_expected.to be_empty
      end
    end
  end
end
