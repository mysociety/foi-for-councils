# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CaseManagement::Icasework, type: :model do
  describe '.configure!' do
    subject { described_class.configure!(params) }

    let(:params) { { account: 'foo', api_key: 'key', secret_key: 'secret' } }

    before do
      expect(Icasework).to receive(:env=).with(Rails.env)
      expect(Icasework).to receive(:account=).with('foo')
      expect(Icasework).to receive(:api_key=).with('key')
      expect(Icasework).to receive(:secret_key=).with('secret')
    end

    it { is_expected.to eq(params) }
  end

  describe '#name' do
    subject { described_class.new.name }
    it { is_expected.to eq('CaseManagement::Icasework') }
  end

  describe '#submit_foi_request!' do
    subject do
      case_management.submit_foi_request!(name: request_attrs[:name],
                                          email: request_attrs[:email],
                                          body: request_attrs[:body])
    end

    let(:case_management) { described_class.new(client: client) }
    let(:client) do
      double(create: Icasework::Case.new(case_details: { case_id: 'FOI-001' }))
    end

    let(:request_attrs) do
      { name: 'John Doe',
        email: 'john@example.com',
        body: 'Some information' }
    end

    it 'submits the request with the required parameters' do
      parameters = { type: 'InformationRequest',
                     request_method: 'Online Form',
                     customer: {
                       name: request_attrs[:name],
                       email: request_attrs[:email]
                     },
                     details: request_attrs[:body] }

      expect(client).to receive(:create).with(parameters)
      subject
    end

    it 'returns the result as a SubmittedRequest' do
      expect(subject).to be_a(described_class::SubmittedRequest)
      expect(subject.reference).to eq('FOI-001')
    end
  end
end
