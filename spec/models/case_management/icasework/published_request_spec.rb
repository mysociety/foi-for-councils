# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CaseManagement::Icasework::PublishedRequest, type: :model do
  let(:request) { described_class.new(api_response) }

  let(:api_response) do
    Icasework::Case.new(attributes)
  end

  let(:attributes) do
    { case_details: { case_id: 'FOI-001' } }
  end

  describe '#reference' do
    subject { request.reference }
    it { is_expected.to eq('FOI-001') }
  end

  describe '#to_h' do
    subject { request.to_h }

    it 'returns expected key/values pairs' do
      is_expected.to eq(reference: 'FOI-001')
    end
  end

  describe '#==' do
    subject { request == other }

    context 'when they encapsulate the same request' do
      let(:other) { described_class.new(api_response) }
      it { is_expected.to eq(true) }
    end

    context 'when the encapsulated request is different' do
      let(:other) { described_class.new(double) }
      it { is_expected.to eq(false) }
    end
  end
end
