# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CaseManagement::Infreemation, type: :model do
  describe '.configure!' do
    subject { described_class.configure!(params) }

    let(:params) { { url: 'example.com', username: 'foo', api_key: 'secret' } }

    before do
      expect(Infreemation).to receive(:logger=).with(Rails.logger)
      expect(Infreemation).to receive(:url=).with('example.com')
      expect(Infreemation).to receive(:username=).with('foo')
      expect(Infreemation).to receive(:api_key=).with('secret')
    end

    it { is_expected.to eq(params) }
  end

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

  describe '#published_requests' do
    subject { case_management.published_requests(query_params) }

    let(:case_management) { described_class.new(client: client) }
    let(:client) { double(where: published_requests) }
    let(:published_requests) { [double, double] }

    let(:query_params) { { start_date: start_date, end_date: end_date } }
    let(:start_date) { Time.zone.today.beginning_of_year }
    let(:end_date) { Time.zone.today }

    it 'queries the API with the required parameters' do
      parameters = { rt: 'published',
                     startdate: start_date,
                     enddate: end_date }

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
end
