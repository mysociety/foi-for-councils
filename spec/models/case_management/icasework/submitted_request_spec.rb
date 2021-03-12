# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CaseManagement::Icasework::SubmittedRequest, type: :model do
  describe '#reference' do
    subject { request.reference }

    let(:request) { described_class.new(api_response) }

    let(:api_response) do
      Icasework::Case.new(
        case_details: { case_id: 'FOI-001' }
      )
    end

    it { is_expected.to eq('FOI-001') }
  end
end
