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

  describe '#published_requests' do
    subject { case_management.published_requests(query_params) }

    let(:case_management) { described_class.new(client: client) }
    let(:client) { double(where: published_requests) }
    let(:published_requests) { [double, double] }

    let(:query_params) { { start_date: start_date, end_date: end_date } }
    let(:start_date) { Time.zone.today.beginning_of_year }
    let(:end_date) { Time.zone.today }

    it 'queries the API with the required parameters' do
      parameters = { type: 'InformationRequest',
                     from: start_date,
                     until: end_date }

      expect(client).to receive(:where).with(parameters)
      subject
    end

    it 'returns a collection of results as PublishedRequests' do
      expected = published_requests.map do |request|
        described_class::PublishedRequest.new(request)
      end

      expect(subject).to match_array(expected)
    end
  end

  describe '#generate_url' do
    subject { case_management.generate_url(published_request) }
    let(:case_management) { described_class.new(client: double) }
    let(:published_request) { double(reference: '1234', payload: payload) }

    let(:payload) do
      {
        documents: [
          { id: 'C225759',
            name: 'Acknowledgement',
            category: 'Correspondence',
            code: 'IRACK',
            type: 'text/html',
            source: 'Correspondence',
            author: 'iCasework Support',
            document_date: '2021-02-15T16:42:36',
            __content__: 'https://example.com/doc/C225759-expired' },
          { id: 'C225758',
            name: 'Acknowledgement of receipt',
            category: 'Correspondence',
            code: 'IRACKRECEIPT',
            type: 'text/html',
            source: 'Correspondence',
            author: 'System',
            document_date: '2021-02-15T16:43:20',
            __content__: 'https://example.com/doc/C225758-expired' },
          { id: 'D225852',
            name: 'Response manually added',
            category: 'General upload',
            type: 'application/pdf',
            source: 'Document',
            document_date: '2021-02-15T16:43:11',
            __content__: 'https://example.com/doc/D225852-expired' },
          { id: 'D225851',
            name: 'Response (some not held)',
            category: 'General upload',
            type: 'application/pdf',
            source: 'Document',
            document_date: '2021-02-15T16:43:11',
            __content__: 'https://example.com/doc/D225851-expired' },
          { id: 'D59321',
            name: 'Sunset.jpg',
            category: 'General upload',
            type: 'image/jpeg',
            source: 'Document',
            document_date: '2021-02-15T16:42:47',
            __content__: 'https://example.com/doc/D59321-expired' }
        ]
      }.stringify_keys
    end

    before do
      expect(Icasework::Document).
        to receive(:find).with(
          case_id: '1234', document_id: 'D225851', self_service: 'True'
        ).and_return(double(url: 'https://example.com/doc/D225851'))
    end

    it { is_expected.to eq('https://example.com/doc/D225851') }
  end
end
