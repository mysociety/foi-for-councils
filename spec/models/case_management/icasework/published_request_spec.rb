# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CaseManagement::Icasework::PublishedRequest, type: :model do
  let(:request) { described_class.new(api_response) }

  let(:api_response) do
    Icasework::Case.new(attributes)
  end

  let(:attributes) do
    {
      case_details: {
        case_id: '000001',
        case_type: 'Information request',
        case_label: 'IR - An information request about budget'
      },
      case_status: {
        status: 'Some information sent but not all held'
      },
      case_status_receipt: {
        method: 'Online Form',
        time_created: '2021-02-15T16:42:19'
      },
      attributes: {
        details: 'Please provide the amount spent on printers in 2020.',
        information_will_be: 'Embedded in the response',
        publish_in_the_disclosure_log: 'Yes',
        reason_information_not_held: 't',
        suitable_for_publication_scheme: 'Yes'
      },
      classifications: [
        { group: 'G1', __content__: 'Bins' },
        { group: 'G2', __content__: 'Waste' },
        { group: 'G3', __content__: 'Missed bins' }
      ],
      documents: [
        { name: 'Response (all information to be supplied)',
          type: 'applicaion/pdf',
          __content__: 'https://example.com/?ref=D225851&access_token=FOO' }
      ]
    }
  end

  describe '#reference' do
    subject { request.reference }
    it { is_expected.to eq('000001') }
  end

  describe '#title' do
    subject { request.title }
    it { is_expected.to eq('An information request about budget') }
  end

  describe '#url' do
    subject { request.url }
    it { is_expected.to be_nil }
  end

  describe '#summary' do
    subject { request.summary }
    it { is_expected.to eq(<<-TEXT.strip_heredoc.chomp.squish) }
    Please provide the amount spent on printers in 2020.
    TEXT
  end

  describe '#keywords' do
    subject { request.keywords }
    it { is_expected.to eq('G1, Bins, G2, Waste, G3, Missed bins') }
  end

  describe '#published_at' do
    subject { request.published_at }
    it { is_expected.to eq(Date.parse('2021-02-15')) }
  end

  describe '#publishable?' do
    subject { request.publishable? }

    context 'when publish_in_the_disclosure_log is Yes' do
      before { attributes[:attributes][:publish_in_the_disclosure_log] = 'Yes' }
      it { is_expected.to eq(true) }
    end

    context 'when publish_in_the_disclosure_log is not Yes' do
      before { attributes[:attributes][:publish_in_the_disclosure_log] = 'No' }
      it { is_expected.to eq(false) }
    end

    context 'when publish_in_the_disclosure_log is blank' do
      before { attributes[:attributes][:publish_in_the_disclosure_log] = '' }
      it { is_expected.to eq(false) }
    end

    context 'when publish_in_the_disclosure_log is empty' do
      before { attributes[:attributes][:publish_in_the_disclosure_log] = nil }
      it { is_expected.to eq(false) }
    end
  end

  describe '#api_created_at' do
    subject { request.api_created_at }
    it { is_expected.to eq(Date.parse('2021-02-15')) }
  end

  describe '#payload' do
    subject { request.payload }
    it { is_expected.to eq(attributes) }
  end

  describe '#to_h' do
    subject { request.to_h }

    let(:summary) do
      <<-TEXT.strip_heredoc.chomp.squish
      Please provide the amount spent on printers in 2020.
      TEXT
    end

    it do
      is_expected.to eq(
        reference: '000001',
        title: 'An information request about budget',
        url: nil,
        summary: summary,
        keywords: 'G1, Bins, G2, Waste, G3, Missed bins',
        published_at: Date.parse('2021-02-15'),
        api_created_at: Date.parse('2021-02-15'),
        publishable: true,
        case_management: 'CaseManagement::Icasework',
        payload: attributes
      )
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