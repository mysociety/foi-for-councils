# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CaseManagement::Infreemation::PublishedRequest, type: :model do
  let(:request) { described_class.new(api_response) }

  let(:api_response) do
    Infreemation::Request.new(attributes)
  end

  let(:attributes) do
    {
      ref: 'FOI-001',
      title: 'An FOI Request',
      url: 'https://foi.example.com/FOI-001',
      requestbody: 'Initial FOI Request',
      history: {
        response: [
          { responsebody: "Dear Redacted\nFOI Response" },
          { responsebody: "Dear Redacted\nAutomated acknowledgement." }
        ]
      },
      keywords: 'bins, waste, missed bins',
      datepublished: '2018-01-05',
      datecreated: '2018-01-01'
    }
  end

  describe '#reference' do
    subject { request.reference }
    it { is_expected.to eq('FOI-001') }
  end

  describe '#title' do
    subject { request.title }
    it { is_expected.to eq('An FOI Request') }
  end

  describe '#url' do
    subject { request.url }
    it { is_expected.to eq('https://foi.example.com/FOI-001') }
  end

  describe '#summary' do
    subject { request.summary }
    it { is_expected.to eq(<<-TEXT.strip_heredoc.chomp.squish) }
    Initial FOI Request
    Dear Redacted
    Automated acknowledgement.
    Dear Redacted
    FOI Response
    TEXT
  end

  describe '#keywords' do
    subject { request.keywords }
    it { is_expected.to eq('bins, waste, missed bins') }
  end

  describe '#published_at' do
    subject { request.published_at }

    context 'when there is a datepublished' do
      it { is_expected.to eq(Date.parse('2018-01-05')) }
    end

    context 'when datepublished is empty' do
      before { attributes[:datepublished] = nil }
      it { is_expected.to be_nil }
    end
  end

  describe '#publishable?' do
    subject { request.publishable? }

    context 'when there is a datepublished' do
      it { is_expected.to eq(true) }
    end

    context 'when datepublished is blank' do
      before { attributes[:datepublished] = '' }
      it { is_expected.to eq(false) }
    end

    context 'when datepublished is empty' do
      before { attributes[:datepublished] = nil }
      it { is_expected.to eq(false) }
    end
  end

  describe '#api_created_at' do
    subject { request.api_created_at }
    it { is_expected.to eq(Date.parse('2018-01-01')) }
  end

  describe '#payload' do
    subject { request.payload }
    it { is_expected.to eq(attributes) }
  end

  describe '#to_h' do
    subject { request.to_h }

    let(:summary) do
      <<-TEXT.strip_heredoc.chomp.squish
      Initial FOI Request
      Dear Redacted
      Automated acknowledgement.
      Dear Redacted
      FOI Response
      TEXT
    end

    it do
      is_expected.to eq(
        reference: 'FOI-001',
        title: 'An FOI Request',
        url: 'https://foi.example.com/FOI-001',
        summary: summary,
        keywords: 'bins, waste, missed bins',
        published_at: Date.parse('2018-01-05'),
        api_created_at: Date.parse('2018-01-01'),
        publishable: true,
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
