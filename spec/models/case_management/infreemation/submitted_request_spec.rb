# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CaseManagement::Infreemation::SubmittedRequest, type: :model do
  describe '#reference' do
    subject { request.reference }

    let(:request) { described_class.new(api_response) }

    let(:api_response) do
      Infreemation::Request.new(
        rt: 'create',
        type: 'FOI',
        contacttype: 'email',
        requester: 'Alice Brown',
        contact: 'alice@example.com',
        body: 'An FOI request',
        status: 'OK',
        ref: 'FOI-001',
        error: ''
      )
    end

    it { is_expected.to eq('FOI-001') }
  end
end
