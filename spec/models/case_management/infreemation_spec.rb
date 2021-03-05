# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CaseManagement::Infreemation, type: :model do
  describe '#submit_foi_request!' do
    subject do
      case_management.submit_foi_request!(name: request_attrs[:name],
                                          email: request_attrs[:email],
                                          body: request_attrs[:body])
    end

    let(:case_management) { described_class.new(client: client) }
    let(:client) { double(create!: Infreemation::Request.new(ref: 'FOI-001')) }

    let(:request_attrs) do
      { name: 'John Doe',
        email: 'john@example.com',
        body: 'Some information' }
    end

    it 'submits the request with the required parameters' do
      parameters = { rt: 'create',
                     type: 'FOI',
                     contacttype: 'email',
                     requester: request_attrs[:name],
                     contact: request_attrs[:email],
                     body: request_attrs[:body] }

      expect(client).to receive(:create!).with(parameters)
      subject
    end

    it 'returns the result as a SubmittedRequest' do
      expect(subject).to be_a(described_class::SubmittedRequest)
      expect(subject.reference).to eq('FOI-001')
    end
  end
end